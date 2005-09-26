#------------------------------------------------------------------------------
package Tags2::Validator;
#------------------------------------------------------------------------------
# $Id: Validator.pm,v 1.2 2005-09-26 18:42:24 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# DTD file. 
	$self->{'dtd_file'} = '';

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
