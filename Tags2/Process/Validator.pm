#------------------------------------------------------------------------------
package Tags2::Process::Validator;
#------------------------------------------------------------------------------
# $Id: Validator.pm,v 1.5 2008-05-18 10:11:02 skim Exp $

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

#------------------------------------------------------------------------------
sub check($$) {
#------------------------------------------------------------------------------
# Check structure opposite dtd struct.

	my ($self, $data) = @_;
}

1;

=pod

=head1 NAME

 Tags2::Process::Validator - Validator class for 'Tags2' structure.

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

 L<Error::Simple::Multiple(3pm)>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION 

 0.01

=cut
