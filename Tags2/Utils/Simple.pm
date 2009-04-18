#------------------------------------------------------------------------------
package Tags2::Utils::Simple;
#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
sub register {
#------------------------------------------------------------------------------
# Register tags object to this module.

	my $tags_obj = shift;
	if (! $tags_obj || (! $tags_obj->isa('Tags2::Output::Debug')
		&& ! $tags_obj->isa('Tags2::Output::ESIS')
		&& ! $tags_obj->isa('Tags2::Output::Indent')
		&& ! $tags_obj->isa('Tags2::Output::Indent2')
		&& ! $tags_obj->isa('Tags2::Output::LibXML')
		&& ! $tags_obj->isa('Tags2::Output::PYX')
		&& ! $tags_obj->isa('Tags2::Output::Raw')
		&& ! $tags_obj->isa('Tags2::Output::SESIS'))) {

		err "Bad Tags2 object.\n";
	}
	$TAGS_OBJ = $tags_obj;
}

#------------------------------------------------------------------------------
sub put_a {
#------------------------------------------------------------------------------
# Put attributes.

	$TAGS_OBJ->put(['a', @_]);
}

#------------------------------------------------------------------------------
sub put_b {
#------------------------------------------------------------------------------
# Put begin of tag.

	$TAGS_OBJ->put(['b', @_]);
}

#------------------------------------------------------------------------------
sub put_c {
#------------------------------------------------------------------------------
# Put comment.

	$TAGS_OBJ->put(['c', @_]);
}

#------------------------------------------------------------------------------
sub put_cd {
#------------------------------------------------------------------------------
# Put cdata.

	$TAGS_OBJ->put(['cd', @_]);
}

#------------------------------------------------------------------------------
sub put_d {
#------------------------------------------------------------------------------
# Put data.

	$TAGS_OBJ->put(['d', @_]);
}

#------------------------------------------------------------------------------
sub put_e {
#------------------------------------------------------------------------------
# Put end of tag.

	$TAGS_OBJ->put(['e', @_]);
}

#------------------------------------------------------------------------------
sub put_i {
#------------------------------------------------------------------------------
# Put instruction.

	$TAGS_OBJ->put(['i', @_]);
}

#------------------------------------------------------------------------------
sub put_r {
#------------------------------------------------------------------------------
# Put raw data.

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

=item B<register()>

 TODO

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

L<Error::Simple::Multiple(3pm)>,
L<Exporter(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 VERSION

0.01

=cut
