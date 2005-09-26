#------------------------------------------------------------------------------
package Tags2::Simple;
#------------------------------------------------------------------------------
# $Id: Simple.pm,v 1.4 2005-09-26 18:42:24 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple;
use Exporter;

# Version.
our $VERSION = 0.01;

# Global variables.
use vars qw($tags_obj);

# Inheritance.
our @ISA = qw(Exporter);

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
	unless ($tags_obj && $tags_obj->isa('Tags2')) {
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

1;
