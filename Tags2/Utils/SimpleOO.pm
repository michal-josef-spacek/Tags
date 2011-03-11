package Tags2::Utils::SimpleOO;

# Pragmas.
use strict;
use warnings;

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my (undef, $tags) = @_;
	return $tags;
}

# Put attributes.
sub put_a {
	my ($self, @data) = @_;
	$self->put(['a', @data]);
	return;
}

# Put begin of tag.
sub put_b {
	my ($self, @data) = @_;
	$self->put(['b', @data]);
	return;
}

# Put comment.
sub put_c {
	my ($self, @data) = @_;
	$self->put(['c', @data]);
	return;
}

# Put cdata.
sub put_cd {
	my ($self, @data) = @_;
	$self->put(['cd', @data]);
	return;
}

# Put data.
sub put_d {
	my ($self, @data) = @_;
	$self->put(['d', @data]);
	return;
}

# Put end of tag.
sub put_e {
	my ($self, @data) = @_;
	$self->put(['e', @data]);
	return;
}

# Put instruction.
sub put_i {
	my ($self, @data) = @_;
	$self->put(['i', @data]);
	return;
}

# Put raw data.
sub put_r {
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

=item C<put_a()>

 TODO

=item C<put_b()>

 TODO

=item C<put_c()>

 TODO

=item C<put_cd()>

 TODO

=item C<put_d()>

 TODO

=item C<put_e()>

 TODO

=item C<put_i()>

 TODO

=item C<put_r()>

 TODO

=back

=head1 DEPENDENCIES

Readonly(3pm).

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
