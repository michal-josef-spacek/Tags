#------------------------------------------------------------------------------
package Tags2::Output::Raw;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use List::MoreUtils qw(none);
use Readonly;
use Tags2::Utils::Preserve;
use Tags2::Utils qw(encode_base_entities);

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $LAST_INDEX => -1;
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.06;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Attribute delimeter.
	$self->{'attr_delimeter'} = q{"};

	# Auto-flush.
	$self->{'auto_flush'} = 0;

	# CDATA callback.
	$self->{'cdata_callback'} = undef;

	# Data callback.
	$self->{'data_callback'} = \&encode_base_entities;

	# No simple tags.
	$self->{'no_simple'} = [];

	# Output handler.
	$self->{'output_handler'} = undef;

	# Output separator.
	$self->{'output_sep'} = $EMPTY_STR;

	# Preserved tags.
	$self->{'preserved'} = [];

	# Raw data callback.
	$self->{'raw_callback'} = undef;

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# XML output.
	$self->{'xml'} = 0;

	# Process params.
	while (@params) {
		my $key = shift @params;
		my $val = shift @params;
		if (! exists $self->{$key}) {
			err "Unknown parameter '$key'.";
		}
		$self->{$key} = $val;
	}

	# Check 'attr_delimeter'.
	if ($self->{'attr_delimeter'} ne q{"}
		&& $self->{'attr_delimeter'} ne q{'}) {

		err "Bad attribute delimeter '$self->{'attr_delimeter'}'.";
	}

	# Check to output handler.
	if (defined $self->{'output_handler'} 
		&& ref $self->{'output_handler'} ne 'GLOB') {

		err 'Output handler is bad file handler.';
	}

	# Check auto-flush only with output handler.
	if ($self->{'auto_flush'} && ! defined $self->{'output_handler'}) {
		err 'Auto-flush can\'t use without output handler.';
	}

	# Initialization.
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

	# Flush code.
	$self->{'flush_code'} = $EMPTY_STR;

	# Tmp code.
	$self->{'tmp_code'} = [];
	$self->{'tmp_comment_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Preserved object.
	$self->{'preserve_obj'} = Tags2::Utils::Preserve->new(
		'preserved' => $self->{'preserved'},
	);

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _flush_tmp {
#------------------------------------------------------------------------------
# Flush $self->{'tmp_code'}.

	my ($self, $string) = @_;

	# Added string.
	push @{$self->{'tmp_code'}}, $string;

	# Detect preserve mode.
	my ($pre, $pre_pre) = $self->{'preserve_obj'}->get;
	if ($pre && ! $pre_pre) {
		push @{$self->{'tmp_code'}}, "\n";
	}

	# Flush comment code before tag.
	if ($self->{'comment_flag'} == 0
		&& scalar @{$self->{'tmp_comment_code'}}) {

		$self->{'flush_code'} .= join $EMPTY_STR,
			@{$self->{'tmp_comment_code'}},
			@{$self->{'tmp_code'}};

	# After tag.
	} else {
		$self->{'flush_code'} .= join $EMPTY_STR,
			@{$self->{'tmp_code'}},
			@{$self->{'tmp_comment_code'}};
	}

	# Resets tmp_codes.
	$self->{'tmp_code'} = [];
	$self->{'tmp_comment_code'} = [];

	return;
}

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, $attr, $value) = @_;

	# Check to 'tmp_code'.
	if (! scalar @{$self->{'tmp_code'}}) {
		err 'Bad tag type \'a\'.';
	}

	# Check to pairs in XML mode.
	if ($self->{'xml'} && ! $value) {
		err 'In XML mode must be a attribute value.';
	}

	# Process attribute.
	my $full_attr = $attr;
	if ($value) {
		$full_attr .= q{=}.$self->{'attr_delimeter'}.
			$value.$self->{'attr_delimeter'};
	}	
	push @{$self->{'tmp_code'}}, $SPACE, $full_attr;

	# Reset comment flag.
	$self->{'comment_flag'} = 0;

	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $tag) = @_;

	# Flush tmp code.
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}

	# XXX Is really?
	# Check to lowercased chars for XML.
	if ($self->{'xml'} && $tag ne lc $tag) {
		err 'In XML must be lowercase tag name.';
	}

	# Push begin of tag to tmp code.
	push @{$self->{'tmp_code'}}, "<$tag";

	# Added tag to printed tags.
	unshift @{$self->{'printed_tags'}}, $tag;

	$self->{'preserve_obj'}->begin($tag);

	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;

	# Flush tmp code.
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}

	# Added begin of cdata section.
	unshift @cdata, '<![CDATA[';

	# Check to bad cdata.
	if (join($EMPTY_STR, @cdata) =~ /]]>$/ms) {
		err 'Bad CDATA data.'
	}

	# Added end of cdata section.
	push @cdata, ']]>';

	# Process data callback.
	$self->_process_callback(\@cdata, 'cdata_callback');

	# To flush code.
	$self->{'flush_code'} .= join $EMPTY_STR, @cdata;

	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;

	# Comment string.
	unshift @comments, '<!--';
	if (substr($comments[$LAST_INDEX], $LAST_INDEX) eq q{-}) {
		push @comments, ' -->';
	} else {
		push @comments, '-->';
	}

	# Process comment.
	my $comment = join $EMPTY_STR, @comments;
	if (scalar @{$self->{'tmp_code'}}) {
		push @{$self->{'tmp_comment_code'}}, $comment;

		# Flag, that means comment is last.
		$self->{'comment_flag'} = 1;
	} else {
		$self->{'flush_code'} .= $comment;
	}

	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @character_data) = @_;

	# Flush tmp code.
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}

	# Process data callback.
	$self->_process_callback(\@character_data, 'data_callback');

	# To flush code.
	$self->{'flush_code'} .= join $EMPTY_STR, @character_data;

	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	my $printed = shift @{$self->{'printed_tags'}};
	if ($self->{'xml'} && $printed ne $tag) {
		err "Ending bad tag: '$tag' in block of ".
			"tag '$printed'.";
	}

	# Tag can be simple.
	if ($self->{'xml'} && (! scalar @{$self->{'no_simple'}}
		|| none { $_ eq $tag } @{$self->{'no_simple'}})) {

		if (scalar @{$self->{'tmp_code'}}) {
			if (scalar @{$self->{'tmp_comment_code'}}
				&& $self->{'comment_flag'} == 1) {

				$self->_flush_tmp('>');
				$self->{'flush_code'} .= "</$tag>";
			} else {
				$self->_flush_tmp(' />');
			}
		} else {
			$self->{'flush_code'} .= "</$tag>";
		}

	# Tag cannot be simple.
	} else {
		if (scalar @{$self->{'tmp_code'}}) {
			$self->_flush_tmp('>');
		}
		$self->{'flush_code'} .= "</$tag>";
	}
	$self->{'preserve_obj'}->end($tag);

	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $target, $code) = @_;

	# Flush tmp code.
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}

	# To flush code.
	$self->{'flush_code'} .= '<?'.$target;
	if ($code) {
		$self->{'flush_code'} .= $SPACE.$code;
	}
	$self->{'flush_code'} .= '?>';

	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, @raw_data) = @_;

	# Flush tmp code.
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}

	# Process data callback.
	$self->_process_callback(\@raw_data, 'raw_callback');

	# To flush code.
	$self->{'flush_code'} .= join $EMPTY_STR, @raw_data;

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::Raw - Raw printing 'Tags2' structure to tags code.

=head1 SYNOPSIS

 use Tags2::Output::Raw;
 my $t = Tags2::Output::Raw->new(%params);
 $t->put(['b', 'tag']);
 $t->finalize;
 $t->flush;
 $t->reset;
 $t->put(['b', 'tag']);
 my @open_tags = $t->open_tags;

=head1 METHODS

=over 8

=item B<new(%params)>

 Constructor.

=over 8

=item * B<attr_delimeter>

 String, that defines attribute delimeter.
 Default is '"'.
 Possible is '"' or "'".

 Example:
 Prints <tag attr='val' /> instead default <tag attr="val" />

 my $t = Tags2::Output::Raw->new(
         'attr_delimeter' => "'",
 );
 $t->put(['b', 'tag'], ['a', 'attr', 'val'], ['e', 'tag']);
 $t->flush;

=item * B<auto_flush>

 Auto flush flag.
 Default is 0.

=item * B<cdata_callback>

 Subroutine for output processing of cdata.
 Input argument is reference to array.
 Default value is undef.
 Example is similar as 'data_callback'.

=item * B<data_callback>

 Subroutine for output processing of data, cdata and raw data.
 Input argument is reference to array.
 Default value is &Tags2::Utils::encode_base_entities.

 Example:
 'data_callback' => sub {
         my $data_arr_ref = shift;
	 foreach my $data (@{$data_arr_ref}) {

	         # Some process.
	         $data =~ s/^\s*//ms;
	 }
 }

=item * B<no-simple>

 Reference to array of tags, that can't by simple.
 Default is [].

 Example:
 That's normal in html pages, web browsers has problem with <script /> tag.
 Prints <script></script> instead <script />.

 my $t = Tags2::Output::Raw->new(
         'no_simple' => ['script'],
 );
 $t->put(['b', 'script'], ['e', 'script']);
 $t->flush;

=item * B<output_handler>

 Handler for print output strings.
 Default is undef.

=item * B<preserved>

 TODO
 Default is reference to blank array.

=item * B<raw_callback>

 Subroutine for output processing of raw data.
 Input argument is reference to array.
 Default value is undef.
 Example is similar as 'data_callback'.

=item * B<skip_bad_tags>

 TODO
 Default is 0.

=item * B<xml>

 Flag, that means xml output.
 Default is 0 (sgml).

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

 Output handler is bad file handler.
 In XML mode must be a attribute value.
 In XML must be lowercase tag name.
 TODO

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Output::Raw;

 # Object.
 my $tags = Tags2::Output::Raw->new;

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

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Encode;
 use Tags2::Output::Raw;

 # Object.
 my $tags = Tags2::Output::Raw->new(
         'data_callback' => sub {
	         my $data_arr_ref = shift;
		 foreach my $data (@{$data_arr_ref}) {
		         $data = encode_utf8($data);
		 }
	 },
 );

 # Data in characters.
 my $data = decode_utf8('řčěšřšč');

 # Put data.
 $tags->put(
         ['b', 'text'],
	 ['d', $data],
	 ['e', 'text'],
 );

 # Print.
 print $tags->flush."\n";

 # Output:
 # <text>řčěšřšč</text>

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<List::MoreUtils(3pm)>,
L<Readonly(3pm)>,
L<Tags2::Utils::Preserve(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::PYX(3pm)>,
L<Tags2::Output::SESIS(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.06

=cut
