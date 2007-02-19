#------------------------------------------------------------------------------
package Tags2::Process::Validator;
#------------------------------------------------------------------------------
# $Id: Validator.pm,v 1.3 2007-02-19 23:45:22 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# DTD structure. 
	$self->{'dtd'} = '';

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Object.
	return $self;
}

1;

=pod

=head1 NAME

 Tags2::Process::Validator - TODO

=head1 SYNOPSIS

 TODO

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=head2 PARAMETERS

=over 8

=item B<dtd>

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
