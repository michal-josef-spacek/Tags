#------------------------------------------------------------------------------
package Tags2::Utils::SimpleOO;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Scalar our $VERSION => 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my (undef, $tags) = @_;
	return $tags;
}

#------------------------------------------------------------------------------
sub put_a {
#------------------------------------------------------------------------------
# Put attributes.

	my ($self, @data) = @_;
	$self->put(['a', @data]);
	return;
}

#------------------------------------------------------------------------------
sub put_b {
#------------------------------------------------------------------------------
# Put begin of tag.

	my ($self, @data) = @_;
	$self->put(['b', @data]);
	return;
}

#------------------------------------------------------------------------------
sub put_c {
#------------------------------------------------------------------------------
# Put comment.

	my ($self, @data) = @_;
	$self->put(['c', @data]);
	return;
}

#------------------------------------------------------------------------------
sub put_cd {
#------------------------------------------------------------------------------
# Put cdata.

	my ($self, @data) = @_;
	$self->put(['cd', @data]);
	return;
}

#------------------------------------------------------------------------------
sub put_d {
#------------------------------------------------------------------------------
# Put data.

	my ($self, @data) = @_;
	$self->put(['d', @data]);
	return;
}

#------------------------------------------------------------------------------
sub put_e {
#------------------------------------------------------------------------------
# Put end of tag.

	my ($self, @data) = @_;
	$self->put(['e', @data]);
	return;
}

#------------------------------------------------------------------------------
sub put_i {
#------------------------------------------------------------------------------
# Put instruction.

	my ($self, @data) = @_;
	$self->put(['i', @data]);
	return;
}

#------------------------------------------------------------------------------
sub put_r {
#------------------------------------------------------------------------------
# Put raw data.

	my ($self, @data) = @_;
	$self->put(['r', @data]);
	return;
}
1;

__END__

=pod

=encoding utf8

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

=item B<put_cd()>

 TODO

=item B<put_d()>

 TODO

=item B<put_e()>

 TODO

=item B<put_i()>

 TODO

=item B<put_r()>

 TODO

=back

=head1 DEPENDENCIES

 Readonly(3pm).

=head1 AUTHOR

 Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

 BSD license.

=head1 VERSION

 0.01

=cut
