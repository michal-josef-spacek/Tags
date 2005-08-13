#------------------------------------------------------------------------------
package Tags2::Indent;
#------------------------------------------------------------------------------
# $Id: Indent.pm,v 1.1 2005-08-13 20:39:57 skim Exp $

# Pragmas.
use strict;

# Modules.
use Carp;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Set indent.
	$self->{'set_indent'} = 0;

	# Indent params.
	$self->{'next_indent'} = '  ';
	$self->{'line_size'} = 79;
	$self->{'linebreak'} = "\n";

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                croak "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Class.
	$self->{'class'} = $class;

	# Object.
	return $self;
}

1;
