#------------------------------------------------------------------------------
package Tags2::Utils::SimpleOO;
#------------------------------------------------------------------------------
# $Id: SimpleOO.pm,v 1.3 2007-02-21 00:36:28 skim Exp $

# Pragmas.
use strict;

# TODO Bad module.
# Modules.
use Tags2;

# Version.
our $VERSION = 0.01;

# TODO Bad module.
# Inheritance.
our @ISA = qw(Tags2);

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless $class->SUPER::new(@_), $class;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub put_c {
#------------------------------------------------------------------------------
# Put comment.

	my $self = shift;
	$self->put(['c', @_]);
}

#------------------------------------------------------------------------------
sub put_b {
#------------------------------------------------------------------------------
# Put begin of tag.

	my $self = shift;
	$self->put(['b', @_]);
}

#------------------------------------------------------------------------------
sub put_e {
#------------------------------------------------------------------------------
# Put end of tag.

	my $self = shift;
	$self->put(['e', @_]);
}

#------------------------------------------------------------------------------
sub put_i {
#------------------------------------------------------------------------------
# Put instruction.

	my $self = shift;
	$self->put(['i', @_]);
}

#------------------------------------------------------------------------------
sub put_d {
#------------------------------------------------------------------------------
# Put data.

	my $self = shift;
	$self->put(['d', @_]);
}

#------------------------------------------------------------------------------
sub put_a {
#------------------------------------------------------------------------------
# Put attributes.

	my $self = shift;
	$self->put(['a', @_]);
}

1;

=pod

=head1 NAME

 Tag2::Utils::SimpleOO - Class that simplifies tags data putting.

=head1 SYNOPSIS

 TODO

=head1 METHODS

=over 8

=item B<put_a()>

 TODO

=item B<put_b()>

 TODO

=item B<put_c()>

 TODO

=item B<put_d()>

 TODO

=item B<put_e()>

 TODO

=item B<put_i()>

 TODO

=back

=head1 REQUIREMENTS

 TODO

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
