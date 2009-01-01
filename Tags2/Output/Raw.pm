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

# Constants.
Readonly::Scalar my $EMPTY => q{};
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.05;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Auto-flush.
	$self->{'auto_flush'} = 0;

	# Attribute delimeter.
	$self->{'attr_delimeter'} = '"';

	# No simple tags.
	$self->{'no_simple'} = [];

	# Set output handler.
	$self->{'output_handler'} = $EMPTY;

	# Preserved tags.
	$self->{'preserved'} = [];

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

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
	if ($self->{'auto_flush'} && $self->{'output_handler'} eq $EMPTY) {
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
	$self->{'flush_code'} = $EMPTY;

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

	# Get tmp_code.
	push @{$self->{'tmp_code'}}, $string if $string;
	my ($pre, $pre_pre) = $self->{'preserve_obj'}->get;
	if ($pre && ! $pre_pre) {
		push @{$self->{'tmp_code'}}, "\n";
	}

	# Flush comment code before tag.
	if ($self->{'comment_flag'} == 0
		&& scalar @{$self->{'tmp_comment_code'}}) {

		$self->{'flush_code'} .= join($EMPTY,
			@{$self->{'tmp_comment_code'}},
			@{$self->{'tmp_code'}});

	# After tag.
	} else {
		$self->{'flush_code'} .= join($EMPTY,
			@{$self->{'tmp_code'}},
			@{$self->{'tmp_comment_code'}});
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

	my ($self, $data) = @_;
	if (! scalar @{$self->{'tmp_code'}}) {
		err 'Bad tag type \'a\'.';
	}
	shift @{$data};
	while (@{$data}) {
		my $par = shift @{$data};
		my $val = shift @{$data};
		push @{$self->{'tmp_code'}}, $SPACE, $par.'='.
			$self->{'attr_delimeter'}.$val.
			$self->{'attr_delimeter'};
		$self->{'comment_flag'} = 0;
	}
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $data) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}
	if ($self->{'xml'} && $data->[1] ne lc($data->[1])) {
		err 'In XML must be lowercase tag name.';
	}
	push @{$self->{'tmp_code'}}, "<$data->[1]";
	unshift @{$self->{'printed_tags'}}, $data->[1];
	$self->{'preserve_obj'}->begin($data->[1]);
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, $data) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}
	shift @{$data};
	$self->{'flush_code'} .= '<![CDATA[';
	foreach my $d (@{$data}) {
		$self->{'flush_code'} .= ref $d eq 'SCALAR' ? ${$d}
			: $d;
	}
	err 'Bad CDATA data.' if $self->{'flush_code'} =~ /]]>$/ms;
	$self->{'flush_code'} .= ']]>';
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, $data) = @_;

	# Comment string.
	shift @{$data};
	my $comment_string = '<!--';
	foreach my $d (@{$data}) {
		$comment_string .= ref $d eq 'SCALAR' ? ${$d}
			: $d;
	}
	if (substr($comment_string, -1) eq '-') {
		$comment_string .= $SPACE;
	}
	$comment_string .= '-->';

	# Process comment.
	if (scalar @{$self->{'tmp_code'}}) {
		push @{$self->{'tmp_comment_code'}}, $comment_string;

		# Flag, that means comment is last.
		$self->{'comment_flag'} = 1;
	} else {
		$self->{'flush_code'} .= $comment_string;
	}
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, $data) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}
	shift @{$data};
	foreach my $d (@{$data}) {
		$self->{'flush_code'} .= ref $d eq 'SCALAR' ? ${$d}
			: $d;
	}
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $data) = @_;
	my $printed = shift @{$self->{'printed_tags'}};
	if ($self->{'xml'} && $printed ne $data->[1]) {
		err "Ending bad tag: '$data->[1]' in block of ".
			"tag '$printed'.";
	}

	# Tag can be simple.
	if ($self->{'xml'} && (! scalar @{$self->{'no_simple'}}
		|| none { $_ eq $data->[1] }
		@{$self->{'no_simple'}})) {

		if (scalar @{$self->{'tmp_code'}}) {
			if (scalar @{$self->{'tmp_comment_code'}}
				&& $self->{'comment_flag'} == 1) {

				$self->_flush_tmp('>');
				$self->{'flush_code'}
					.= "</$data->[1]>";
			} else {
				$self->_flush_tmp(' />');
			}
		} else {
			$self->{'flush_code'} .= "</$data->[1]>";
		}

	# Tag cannot be simple.
	} else {
		if (scalar @{$self->{'tmp_code'}}) {
			$self->_flush_tmp('>');
		}
		$self->{'flush_code'} .= "</$data->[1]>";
	}
	$self->{'preserve_obj'}->end($data->[1]);
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $data) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}
	shift @{$data};
	$self->{'flush_code'} .= '<?';
	my $target = shift @{$data};
	$self->{'flush_code'} .= $target;
	while (@{$data}) {
		my $data = shift @{$data};
		$self->{'flush_code'} .= " $data";
	}
	$self->{'flush_code'} .= '?>';
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, $data) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_flush_tmp('>');
	}
	shift @{$data};
	while (@{$data}) {
		my $data = shift @{$data};
		$self->{'flush_code'} .= $data;
	}
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

=item * B<no-simple>

 Reference to array of tags, that can't by simple.
 Default is [].

 Example:
 That's normal in html pages, web browsers has problem with <script /> tag.
 Prints <script></script> instead <script />.

 my $t = Tags2::Output::Raw->new(
   'no_simple' => ['script'
 );
 $t->put(['b', 'script'], ['e', 'script']);
 $t->flush;

=item * B<output_handler>

 Handler for print output strings.
 Default is *STDOUT.

=item * B<preserved>

 TODO
 Default is reference to blank array.

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

 In XML must be lowercase tag name.
 TODO

=head1 EXAMPLE

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

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
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

 0.05

=cut
