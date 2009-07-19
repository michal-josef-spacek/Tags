#------------------------------------------------------------------------------
package Tags2::Process::EntitySubstitute;
#------------------------------------------------------------------------------

# Pragmas.
use encoding 'utf8';
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use List::MoreUtils qw(any);
use Tags2::Utils qw(set_params);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Entity structure.
	$self->{'entity'} = {};

	# Entity characters to encode/decode.
	$self->{'entity_chars'} = [];

	# Process params.
	set_params($self, @params);

	# Check to hash reference in entity parameter.
	if (ref $self->{'entity'} ne 'HASH') {
		err 'Bad \'entity\' hash reference.';
	}

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub encode {
#------------------------------------------------------------------------------
# Encode text strings in data to entity from dtd.

	my ($self, @data) = @_;
	foreach my $i (0 .. $#data) {
		$data[$i] = $self->_encode($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
sub decode {
#------------------------------------------------------------------------------
# Decode entity from dtd to text strings.

	my ($self, @data) = @_;
	foreach my $i (0 .. $#data) {
		$data[$i] = $self->_decode($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
sub encode_chars {
#------------------------------------------------------------------------------
# Encode characters to '&#[0-9]+;' syntax.

	my ($self, @data) = @_;
	foreach my $i (0 .. $#data) {
		$data[$i] = $self->_encode_chars($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
sub decode_chars {
#------------------------------------------------------------------------------
# Decode characters from '&#[0-9]+;' syntax.

	my ($self, @data) = @_;
	foreach my $i (0 .. $#data) {
		$data[$i] = $self->_decode_chars($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _encode {
#------------------------------------------------------------------------------
# Encode.

	my ($self, $data) = @_;
	$data = $self->_decode($data);
	if (any { $_ eq '&' } keys %{$self->{'entity'}}) {
		$data =~ s/&/$self->{'entity'}->{'&'}/gms;
		delete $self->{'entity'}->{'&'}
	}
	foreach my $ent (keys %{$self->{'entity'}}) {
		$data =~ s/(?<!&)$ent/$self->{'entity'}->{$ent}/gmsx;
	}
	return $data;
}

#------------------------------------------------------------------------------
sub _decode {
#------------------------------------------------------------------------------
# Decode.

	my ($self, $data) = @_;
	foreach my $ent (keys %{$self->{'entity'}}) {
		$data =~ s/$self->{'entity'}->{$ent}/$ent/gmsx;
	}
	return $data;
}

#------------------------------------------------------------------------------
sub _encode_chars {
#------------------------------------------------------------------------------
# Encode chars.

	my ($self, $data) = @_;
	$data = $self->_decode_chars($data);
	foreach my $ent_char (@{$self->{'entity_chars'}}) {
		my $tmp = '&#'.ord($ent_char).';';
		$data =~ s/$ent_char/$tmp/gms;
	}
	return $data;
}

#------------------------------------------------------------------------------
sub _decode_chars {
#------------------------------------------------------------------------------
# Decode chars.

	my ($self, $data) = @_;
	$data =~ s/&#(\d+);/chr($1)/egms;
	$data =~ s/&#x([\da-fA-F]+);/chr($1)/egmsx;
	return $data;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Process::EntitySubstitute - Class for entity substitute.

=head1 SYNOPSIS

 TODO

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=over 8

=item B<entity>

 TODO

=item B<entity_chars>

 TODO

=back

=item B<encode($data)>

 TODO

=item B<decode($data)>

 TODO

=item B<encode_chars($data)>

 TODO

=item B<decode_chars($data)>

 TODO

=back

=head1 ERRORS

 Mine:
   Bad 'entity' hash reference.

 From Tags2::Utils:
   Unknown parameter '%s'.

=head1 EXAMPLE

 TODO

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Core(3pm)>,
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
