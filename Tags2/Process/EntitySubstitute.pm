#------------------------------------------------------------------------------
package Tags2::Process::EntitySubstitute;
#------------------------------------------------------------------------------
# $Id: EntitySubstitute.pm,v 1.5 2008-04-18 17:00:33 skim Exp $

# Pragmas.
use strict;
use encoding 'utf8';

# Modules.
use Error::Simple::Multiple;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new($@) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Entity structure. 
	$self->{'entity'} = {};

	# Entity characters to encode/decode.
	$self->{'entity_chars'} = [];

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Check to hash reference in entity parameter.
	if (ref $self->{'entity'} ne 'HASH') {
		err "Bad 'entity' hash reference.";
	}

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub encode($@) {
#------------------------------------------------------------------------------
# Encode text strings in data to entity from dtd.

	my ($self, @data) = @_;
	for (my $i = 0; $i <= $#data; $i++) {
		$data[$i] = $self->_encode($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
sub decode($@) {
#------------------------------------------------------------------------------
# Decode entity from dtd to text strings.

	my ($self, @data) = @_;
	for (my $i = 0; $i <= $#data; $i++) {
		$data[$i] = $self->_decode($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
sub encode_chars($@) {
#------------------------------------------------------------------------------
# Encode characters to '&#[0-9]+;' syntax.

	my ($self, @data) = @_;
	for (my $i = 0; $i <= $#data; $i++) {
		$data[$i] = $self->_encode_chars($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
sub decode_chars($@) {
#------------------------------------------------------------------------------
# Decode characters from '&#[0-9]+;' syntax.

	my ($self, @data) = @_;
	for (my $i = 0; $i <= $#data; $i++) {
		$data[$i] = $self->_decode_chars($data[$i]);
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _encode($$) {
#------------------------------------------------------------------------------
# Encode.

	my ($self, $data) = @_;
	$data = $self->_decode($data);
	if (grep { $_ eq '&' } keys %{$self->{'entity'}}) {
		$data =~ s/&/$self->{'entity'}->{'&'}/g;
		delete $self->{'entity'}->{'&'}
	}
	foreach my $ent (keys %{$self->{'entity'}}) {
		$data =~ s/(?<!&)$ent/$self->{'entity'}->{$ent}/gx;
	}
	return $data;
}

#------------------------------------------------------------------------------
sub _decode($$) {
#------------------------------------------------------------------------------
# Decode.

	my ($self, $data) = @_;
	foreach my $ent (keys %{$self->{'entity'}}) {
		$data =~ s/$self->{'entity'}->{$ent}/$ent/g;
	}
	return $data;
}

#------------------------------------------------------------------------------
sub _encode_chars($$) {
#------------------------------------------------------------------------------
# Encode chars.

	my ($self, $data) = @_;
	$data = $self->_decode_chars($data);
	foreach my $ent_char (@{$self->{'entity_chars'}}) {
		my $tmp = '&#'.ord($ent_char).';';
		$data =~ s/$ent_char/$tmp/g;
	}
	return $data;
}

#------------------------------------------------------------------------------
sub _decode_chars($$) {
#------------------------------------------------------------------------------
# Decode chars.

	my ($self, $data) = @_;
	$data =~ s/&#(\d+);/chr($1)/ge;
	$data =~ s/&#x([\da-fA-F]+);/chr($1)/ge;
	return $data;
}

1;

=pod

=head1 NAME

 Tags2::Process::EntitySubstitute - Class for entity substitute.

=head1 SYNOPSIS

 TODO

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=head2 PARAMETERS

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

=head1 EXAMPLE

 TODO

=head1 REQUIREMENTS

 L<Error::Simple::Multiple>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION 

 0.01

=cut
