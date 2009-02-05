#------------------------------------------------------------------------------
package Tags2::Output::Indent2;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Indent;
use Indent::Word;
use Indent::Block;
use Readonly;
use Tags2::Utils::Preserve;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $LAST_INDEX => -1;
Readonly::Scalar my $LINE_SIZE => 79;
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Auto-flush.
	$self->{'auto_flush'} = 0;

	# Indent params.
	$self->{'next_indent'} = $SPACE x 2;
	$self->{'line_size'} = $LINE_SIZE;
	$self->{'linebreak'} = "\n";

	# Set output handler.
	$self->{'output_handler'} = $EMPTY_STR;

	# No simple tags.
	$self->{'no_simple'} = [];

	# Preserved tags.
	$self->{'preserved'} = [];

	# Attribute delimeter.
	$self->{'attr_delimeter'} = '"';

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# Callback to instruction.
	$self->{'instruction'} = $EMPTY_STR;

	# Indent CDATA section.
	$self->{'cdata_indent'} = 0;

	# XML output.
	$self->{'xml'} = 0;

	# Process params.
	while (@params) {
		my $key = shift @params;
		my $val = shift @params;
		err "Bad parameter '$key'." if ! exists $self->{$key};
		$self->{$key} = $val;
	}

	# Check 'attr_delimeter'.
	if ($self->{'attr_delimeter'} ne '"'
		&& $self->{'attr_delimeter'} ne '\'') {

		err "Bad attribute delimeter '$self->{'attr_delimeter'}'.";
	}

	# Check auto-flush only with output handler.
	if ($self->{'auto_flush'} && $self->{'output_handler'} eq $EMPTY_STR) {
		err '\'auto_flush\' parameter can\'t use without '.
			'\'output_handler\' parameter.';
	}

	# Reset.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub reset {
#------------------------------------------------------------------------------
# Resets internal variables.

	my $self = shift;

	# Comment flag.
	$self->{'comment_flag'} = 0;

	# Indent object.
	$self->{'indent'} = Indent->new(
		'next_indent' => $self->{'next_indent'}
	);

	# Indent::Word object.
	$self->{'indent_word'} = Indent::Word->new(
		'line_size' => $self->{'line_size'},
		'next_indent' => $EMPTY_STR,
	);

	# Indent::Block object.
	$self->{'indent_block'} = Indent::Block->new(
		'line_size' => $self->{'line_size'},
		'next_indent' => $self->{'next_indent'},
		'strict' => 0,
	);

	# Flush code.
	$self->{'flush_code'} = $EMPTY_STR;

	# Tmp code.
	$self->{'tmp_code'} = [];
	$self->{'tmp_comment_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Non indent flag.
	$self->{'non_indent'} = 0;

	# Flag, that means raw tag.
	$self->{'raw_tag'} = 0;

	# Preserved object.
	$self->{'preserve_obj'} = Tags2::Utils::Preserve->new(
		'preserved' => $self->{'preserved'},
	);

	# Process flag.
	$self->{'process'} = 0;

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _flush_code {
#------------------------------------------------------------------------------
# Helper for flush data.

	my ($self, $code) = @_;
	$self->{'process'} = 1 if ! $self->{'process'};
	$self->{'flush_code'} .= $code;
	return;
}

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, @pairs) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $tag) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @data) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $target, $code) = @_;
	if (ref $self->{'instruction'} eq 'CODE') {
		$self->{'instruction'}->($self, $target, $code);
	} else {
		$self->_newline;
		$self->{'preserve_obj'}->save_previous;
		$self->_flush_code($self->{'indent_block'}
			->indent([
			'<?'.$target, $SPACE, $code, '?>',
			$self->{'indent'}->get,
		]));
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, @raw_data) = @_;
	foreach my $data (@raw_data) {
		$self->_flush_code($data);
	}
	$self->{'raw_tag'} = 1;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::Indent2 - Indent class for Tags2.

=head1 SYNOPSIS

 use Tags2::Output::Indent2(%params);
 my $t = Tags2::Output::Indent2->new;
 $t->put(['b', 'tag']);
 $t->finalize;
 $t->flush;
 $t->reset;
 $t->put(['b', 'tag']);
 my @open_tags = $t->open_tags;

=head1 METHODS

=over 8

=item B<new(%params)>

 Constructor

=over 8

=item * B<attr_delimeter>

 String, that defines attribute delimeter.
 Default is '"'.
 Possible is '"' or "'".

 Example:
 Prints <tag attr='val' /> instead default <tag attr="val" />

 my $t = Tags2::Output::Indent->new(
   'attr_delimeter' => "'",
 );
 $t->put(['b', 'tag'], ['a', 'attr', 'val'], ['e', 'tag']);
 $t->flush;

=item * B<auto_flush>

 Auto flush flag.
 Default is 0.

=item * B<cdata_indent>

 Flag, that means indent CDATA section.
 Default value is no-indent (0).

=item * B<line_size>

 TODO
 Default value is 79.

=item * B<next_indent>

 TODO
 Default value is "  ".

=item * B<no_simple>

 Reference to array of tags, that can't by simple.
 Default is [].

 Example:
 That's normal in html pages, web browsers has problem with <script /> tag.
 Prints <script></script> instead <script />.

 my $t = Tags2::Output::Raw->new(
   'no_simple' => ['script']
 );
 $t->put(['b', 'script'], ['e', 'script']);
 $t->flush;

=item * B<output_handler>

 Handler for print output strings.
 Default is *STDOUT.

=item * B<output_separator>

 TODO
 Default value is newline (\n).

=item * B<preserved>

 TODO
 Default is reference to blank array.

=item * B<skip_bad_tags>

 TODO
 Default is 0.

=back

=item B<finalize()>

 Finalize Tags output.
 Automaticly puts end of all opened tags.

=item B<flush($reset_flag)>

 Flush tags in object.
 If defined 'output_handler' flush to its.
 Or return code.
 If enabled $reset_flag, then resets internal variables via reset method.

=item B<open_tags()>

 Return array of opened tags.

=item B<put(@data)>

 Put tags code in tags2 format.

=item B<reset()>

 Resets internal variables.

=back

=head1 ERRORS

 'auto_flush' parameter can't use without 'output_handler' parameter.
 Bad attribute delimeter '%s'.
 Bad CDATA section.
 Bad data.
 Bad parameter '%s'.
 Bad tag type 'a'.
 Bad type of data.
 Ending bad tag: '%s' in block of tag '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Output::Indent2;

 # Object.
 my $tags = Tags2::Output::Indent2->new;

 # Put data.
 $tags->put(
         ['b', 'text'],
	 ['d', 'data'],
	 ['e', 'text'],
 );

 # Print.
 print $tags->flush."\n";

 # Output:
 # <text>data</text>

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Indent(3pm)>,
L<Indent::Word(3pm)>,
L<Indent::Block(3pm)>,
L<Tags2::Utils::Preserve(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Core(3pm)>,
L<Tags2::Output::Debug(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::PYX(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::SESIS(3pm)>.

=head1 AUTHOR

 Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

 BSD license.

=head1 VERSION

 0.01

=cut
