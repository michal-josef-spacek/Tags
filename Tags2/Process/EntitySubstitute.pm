#------------------------------------------------------------------------------
package Tags2::Process::EntitySubstitute;
#------------------------------------------------------------------------------
# $Id: EntitySubstitute.pm,v 1.3 2007-02-21 03:09:32 skim Exp $

# Pragmas.
use strict;

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

	# For every 'Tags2' structure.
	foreach (my $i = 0; $i <= $#data; $i++) {
		if ($data[$i]->[0] eq 'd') {
			for (my $j = 1; $j <= $#{$data[$i]}; $j++) {
				$data[$i]->[$j] 
					= $self->_encode($data[$i]->[$j]);
			}
		}
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
sub decode($@) {
#------------------------------------------------------------------------------
# Decode entoty from dtd to text strings.

	my ($self, @data) = @_;

	# For every 'Tags2' structure.
	foreach (my $i = 0; $i <= $#data; $i++) {
		if ($data[$i]->[0] eq 'd') {
			for (my $j = 1; $j <= $#{$data[$i]}; $j++) {
				$data[$i]->[$j] 
					= $self->_decode($data[$i]->[$j]);
			}
		}
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

=back

=item B<encode($data)>

 TODO

=item B<decode($data)>

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
