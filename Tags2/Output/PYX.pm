#------------------------------------------------------------------------------
package Tags2::Output::PYX;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY => q{};

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Set output handler.
	$self->{'output_handler'} = $EMPTY;

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# Process params.
        while (@params) {
                my $key = shift @params;
                my $val = shift @params;
                err "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Initialization.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub put {
#------------------------------------------------------------------------------
# Put tags code.

	my ($self, @data) = @_;

	# For every data.
	foreach my $dat (@data) {

		# Bad data.
		unless (ref $dat eq 'ARRAY') {
			err 'Bad data.';
		}

		# Detect and process data.
		$self->_detect_data($dat);
	}

	return;
}

#------------------------------------------------------------------------------
sub reset {
#------------------------------------------------------------------------------
# Resets internal variables.

	my $self = shift;

	# Flush code.
	$self->{'flush_code'} = $EMPTY;

	# Printed tags.
	$self->{'printed_tags'} = [];

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
		shift @{$data};
		while (@{$data}) {
			my $par = shift @{$data};
			my $val = shift @{$data};
			$self->{'flush_code'} .= "A$par $val\n";
		}

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		$self->{'flush_code'} .= "($data->[1]\n";
		unshift @{$self->{'printed_tags'}}, $data->[1];

	# Data.
	} elsif ($data->[0] eq 'd') {
		shift @{$data};
		my $tmp_data = $EMPTY;
		foreach my $d (@{$data}) {
			$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
		}
		$self->{'flush_code'} .= '-'.
			$self->_encode_newline($tmp_data)."\n";

	# End of tag.
	} elsif ($data->[0] eq 'e') {
		my $printed = shift @{$self->{'printed_tags'}};
		if ($printed ne $data->[1]) {
			err "Ending bad tag: '$data->[1]' in block of ".
				"tag '$printed'.";
		}
		$self->{'flush_code'} .= ")$data->[1]\n";

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		shift @{$data};
		my $target = shift @{$data};
		my $tmp_data = $EMPTY;
		while (@{$data}) {
			my $data = shift @{$data};
			$tmp_data .= " $data";
		}
		$self->{'flush_code'} .= "?$target ".
			$self->_encode_newline($tmp_data)."\n";

	# Other.
	} else {
		err 'Bad type of data.' if ! $self->{'skip_bad_tags'};
	}

	return;
}

#------------------------------------------------------------------------------
sub _encode_newline {
#------------------------------------------------------------------------------
# Encode newline in data to '\n' in output.

	my ($self, $string) = @_;
	$string =~ s/\n/\\n/gms;
	return $string;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::PYX - PYX class for line oriented output for 'Tags2'.

=head1 SYNOPSYS

 TODO

=head1 SESIS LINE CHARS

 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 -  - Normal data.

=head1 METHODS

=over 8

=item B<new()>

 TODO

=head2 PARAMETERS

=over 8

=item B<output_handler>

 TODO

=item B<skip_bad_data>

 TODO

=back

=item B<finalize()>

 TODO

=item B<flush()>

 TODO

=item B<open_tags()>

 TODO

=item B<put()>

 TODO

=item B<reset()>

 TODO

=back

=head1 EXAMPLE

 TODO

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::SESIS(3pm)>.

=head1 AUTHOR

 Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

 BSD license.

=head1 VERSION

 0.01

=cut
