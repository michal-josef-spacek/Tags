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
Readonly::Scalar our $VERSION => 0.01;

# Global variables.
our $tags_obj;

# Export.
our @EXPORT = qw(register);
our @EXPORT_OK = qw(put_a put_b put_c put_d put_e put_i);
our %EXPORT_TAGS = (
	all => [qw(put_a put_b put_c put_d put_e put_i)],
);

#------------------------------------------------------------------------------
sub register {
#------------------------------------------------------------------------------
# Register tags object to this module.

	$tags_obj = shift;
	if (! $tags_obj || ! $tags_obj->isa('Tags2')) {
		err "Bad Tags2 object.\n";
	}
}

#------------------------------------------------------------------------------
sub put_a {
#------------------------------------------------------------------------------
# Put attributes.

	$tags_obj->put(['a', @_]);
}

#------------------------------------------------------------------------------
sub put_b {
#------------------------------------------------------------------------------
# Put begin of tag.

	$tags_obj->put(['b', @_]);
}

#------------------------------------------------------------------------------
sub put_c {
#------------------------------------------------------------------------------
# Put comment.

	$tags_obj->put(['c', @_]);
}

#------------------------------------------------------------------------------
sub put_cd {
#------------------------------------------------------------------------------
# Put cdata.

	$tags_obj->put(['cd', @_]);
}

#------------------------------------------------------------------------------
sub put_d {
#------------------------------------------------------------------------------
# Put data.

	$tags_obj->put(['d', @_]);
}

#------------------------------------------------------------------------------
sub put_e {
#------------------------------------------------------------------------------
# Put end of tag.

	$tags_obj->put(['e', @_]);
}

#------------------------------------------------------------------------------
sub put_i {
#------------------------------------------------------------------------------
# Put instruction.

	$tags_obj->put(['i', @_]);
}

#------------------------------------------------------------------------------
sub put_r {
#------------------------------------------------------------------------------
# Put raw data.

	$tags_obj->put(['r', @_]);
}

1;

=pod

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

=head1 REQUIREMENTS

 L<Error::Simple::Multiple(3pm)>
 L<Exporter(3pm)>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
