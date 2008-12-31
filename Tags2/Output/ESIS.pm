#------------------------------------------------------------------------------
package Tags2::Output::ESIS;
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
our $VERSION = 0.02;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Output handler.
	$self->{'output_handler'} = $EMPTY;

	# Output separator.
	$self->{'output_sep'} = "\n";

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
sub reset {
#------------------------------------------------------------------------------
# Resets internal variables.

	my $self = shift;

	# Flush code.
	$self->{'flush_code'} = [];

	# Tmp code.
	$self->{'tmp_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _encode_newline {
#------------------------------------------------------------------------------
# Encode newline in data to '\n' in output.

	my ($self, $string) = @_;
	$string =~ s/\n/\\n/gms;
	return $string;
}

#------------------------------------------------------------------------------
sub _flush_tmp {
#------------------------------------------------------------------------------
# Flush tmp.

	my $self = shift;
	if ($self->{'tmp_code'}) {
		push @{$self->{'flush_code'}}, @{$self->{'tmp_code'}};
		$self->{'tmp_code'} = [];
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, $data_ref) = @_;
	shift @{$data_ref};
	while (@{$data_ref}) {
		my $par = shift @{$data_ref};
		my $val = shift @{$data_ref};
		push @{$self->{'flush_code'}}, "A$par $val";
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $data_ref) = @_;
	push @{$self->{'tmp_code'}}, "($data_ref->[1]";
	unshift @{$self->{'printed_tags'}}, $data_ref->[1];
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, $data_ref) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, $data_ref) = @_;
	$self->_flush_tmp;
	shift @{$data_ref};
	my $tmp_data = $EMPTY;
	foreach my $d (@{$data_ref}) {
		$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
	}
	push @{$self->{'flush_code'}},
		'_'.$self->_encode_newline($tmp_data);
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, $data_ref) = @_;
	$self->_flush_tmp;
	shift @{$data_ref};
	my $tmp_data = $EMPTY;
	foreach my $d (@{$data_ref}) {
		$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
	}
	push @{$self->{'flush_code'}},
		'-'.$self->_encode_newline($tmp_data);
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $data_ref) = @_;
	$self->_flush_tmp;
	my $printed = shift @{$self->{'printed_tags'}};
	if ($printed ne $data_ref->[1]) {
		err "Ending bad tag: '$data_ref->[1]' in block of ".
			"tag '$printed'.";
	}
	push @{$self->{'flush_code'}}, ")$data_ref->[1]";
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $data_ref) = @_;
	$self->_flush_tmp;
	shift @{$data_ref};
	my $target = shift @{$data_ref};
	my $tmp_data = $EMPTY;
	while (@{$data_ref}) {
		my $tmp = shift @{$data_ref};
		$tmp_data .= " $tmp";
	}
	push @{$self->{'flush_code'}},
		"?$target".$self->_encode_newline($tmp_data);
	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, $data_ref) = @_;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::ESIS - ESIS class for line oriented output for 'Tags2'.

=head1 SYNOPSYS

 TODO

=head1 ESIS LINE CHARS

 _  - Comment data.
 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 -  - Normal data.

=head1 METHODS

=over 8

=item B<new(%parameters)>

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
L<Tags2::Output::Core(3pm)>,
L<Tags2::Output::Debug(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::Indent2(3pm)>,
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
