#------------------------------------------------------------------------------
package Tags2::Output::Raw;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple;
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
                err "Bad parameter '$key'." unless exists $self->{$key};
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

	# Reset.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub finalize {
#------------------------------------------------------------------------------
# Finalize Tags output.

	my $self = shift;
	while (@{$self->{'printed_tags'}}) {
		$self->put(['e', $self->{'printed_tags'}->[0]]);
	}
	return;
}

#------------------------------------------------------------------------------
sub flush {
#------------------------------------------------------------------------------
# Flush tags in object.

	my ($self, $reset_flag) = @_;
	my $ouf = $self->{'output_handler'};
	my $ret;
	if ($ouf) {
		print {$ouf} $self->{'flush_code'};
	} else {
		$ret = $self->{'flush_code'};
	}

	# Reset.
	if ($reset_flag) {
		$self->reset;
	}

	# Return value.
	return $ret;
}

#------------------------------------------------------------------------------
sub open_tags {
#------------------------------------------------------------------------------
# Return array of opened tags.

	my $self = shift;
	return @{$self->{'printed_tags'}};
}

#------------------------------------------------------------------------------
sub put {
#------------------------------------------------------------------------------
# Put tags code.

	my ($self, @data) = @_;

	# For every data.
	foreach my $dat (@data) {

		# Bad data.
		if (ref $dat ne 'ARRAY') {
			err 'Bad data.';
		}

		# Detect and process data.
		$self->_detect_data($dat);
	}

	# Auto-flush.
	if ($self->{'auto_flush'}) {
		$self->flush;
		$self->{'flush_code'} = $EMPTY;
	}
	return;
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
sub _detect_data {
#------------------------------------------------------------------------------
# Detect and process data.

	my ($self, $data) = @_;

	# Attributes.
	if ($data->[0] eq 'a') {
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

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		if (scalar @{$self->{'tmp_code'}}) {
			$self->_flush_tmp('>');
		}
		if ($self->{'xml'} && $data->[1] ne lc($data->[1])) {
			err 'In XML must be lowercase tag name.';
		}
		push @{$self->{'tmp_code'}}, "<$data->[1]";
		unshift @{$self->{'printed_tags'}}, $data->[1];
		$self->{'preserve_obj'}->begin($data->[1]);

	# Comment.
	} elsif ($data->[0] eq 'c') {

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

	# Cdata.
	} elsif ($data->[0] eq 'cd') {
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

	# Data.
	} elsif ($data->[0] eq 'd') {
		if (scalar @{$self->{'tmp_code'}}) {
			$self->_flush_tmp('>');
		}
		shift @{$data};
		foreach my $d (@{$data}) {
			$self->{'flush_code'} .= ref $d eq 'SCALAR' ? ${$d}
				: $d;
		}

	# End of tag.
	} elsif ($data->[0] eq 'e') {
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

	# Instruction.
	} elsif ($data->[0] eq 'i') {
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

	# Raw data.
	} elsif ($data->[0] eq 'r') {
		if (scalar @{$self->{'tmp_code'}}) {
			$self->_flush_tmp('>');
		}
		shift @{$data};
		while (@{$data}) {
			my $data = shift @{$data};
			$self->{'flush_code'} .= $data;
		}

	# Other.
	} else {
		err 'Bad type of data.' if $self->{'skip_bad_tags'};
	}

	return;
}

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
