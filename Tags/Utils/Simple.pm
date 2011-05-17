package Tags::Utils::Simple;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(put_a put_b put_c put_d put_e put_i
	register);
Readonly::Hash our %EXPORT_TAGS => (
	all => [qw(put_a put_b put_c put_d put_e put_i register)],
);

# Global variables.
our $TAGS_OBJ;

# Version.
our $VERSION = 0.01;

# Register tags object to this module.
sub register {
	my $tags_obj = shift;
	if (! $tags_obj || (! $tags_obj->isa('Tags::Output::Core')
		&& ! $tags_obj->isa('Tags::Output::ESIS')
		&& ! $tags_obj->isa('Tags::Output::Indent')
		&& ! $tags_obj->isa('Tags::Output::Indent2')
		&& ! $tags_obj->isa('Tags::Output::LibXML')
		&& ! $tags_obj->isa('Tags::Output::PYX')
		&& ! $tags_obj->isa('Tags::Output::Raw')
		&& ! $tags_obj->isa('Tags::Output::SESIS'))) {

		err "Bad Tags object.\n";
	}
	$TAGS_OBJ = $tags_obj;
}

# Put attributes.
sub put_a {
	$TAGS_OBJ->put(['a', @_]);
}

# Put begin of tag.
sub put_b {
	$TAGS_OBJ->put(['b', @_]);
}

# Put comment.
sub put_c {
	$TAGS_OBJ->put(['c', @_]);
}

# Put cdata.
sub put_cd {
	$TAGS_OBJ->put(['cd', @_]);
}

# Put data.
sub put_d {
	$TAGS_OBJ->put(['d', @_]);
}

# Put end of tag.
sub put_e {
	$TAGS_OBJ->put(['e', @_]);
}

# Put instruction.
sub put_i {
	$TAGS_OBJ->put(['i', @_]);
}

# Put raw data.
sub put_r {
	$TAGS_OBJ->put(['r', @_]);
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tag2::Utils::Simple - Module that simplifies tags data putting.

=head1 SYNOPSIS

 TODO

=head1 SUBROUTINES

=over 8

=item C<register()>

 TODO

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

L<Error::Simple::Multiple(3pm)>,
L<Exporter(3pm)>.

=head1 SEE ALSO

L<Tags(3pm)>,
L<Tags::Output::Core(3pm)>,
L<Tags::Output::ESIS(3pm)>,
L<Tags::Output::Indent(3pm)>,
L<Tags::Output::LibXML(3pm)>,
L<Tags::Output::PYX(3pm)>,
L<Tags::Output::Raw(3pm)>,
L<Tags::Output::SESIS(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 VERSION

0.01

=cut
