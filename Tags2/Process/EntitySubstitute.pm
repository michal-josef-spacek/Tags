#------------------------------------------------------------------------------
package Tags2::Process::EntitySubstitute;
#------------------------------------------------------------------------------
# $Id: EntitySubstitute.pm,v 1.2 2007-02-21 01:24:15 skim Exp $

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
sub substitute($@) {
#------------------------------------------------------------------------------
# Substitute text strings in data to entity from dtd.

	my ($self, @data) = @_;

	# For every 'Tags2' structure.
	foreach (my $i = 0; $i <= $#data; $i++) {
		if ($data[$i]->[0] eq 'd') {
			$data[$i] = $self->_substitute($data[$i]);
		}
	}

	# Return data.
	return @data;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _substitute($$) {
#------------------------------------------------------------------------------
# Main substitute.

	my ($self, $data) = @_;
	for (my $i = 1; $i <= $#{$data}; $i++) {
		foreach my $ent (keys %{$self->{'entity'}}) {
			$data->[$i] =~ s/$ent\b/$self->{'entity'}->{$ent}/g;
		}
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
