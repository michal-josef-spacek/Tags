#------------------------------------------------------------------------------
package Tags2::Output::Core;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub finalize {
#------------------------------------------------------------------------------
# Finalize Tags output.

	my $self = shift;
	while (@{$self->{'printed_tags'}}) {
		$self->put(['e', $self->{'printed_tags'}->[0]]);
	}
	return;
}

#------------------------------------------------------------------------------
sub flush {
#------------------------------------------------------------------------------
# Flush tags in object.

	my ($self, $reset_flag) = @_;
	my $ouf = $self->{'output_handler'};
	my $ret;
	if ($ouf) {
		print {$ouf} $self->{'flush_code'};
	} else {
		$ret = $self->{'flush_code'};
	}

	# Reset.
	if ($reset_flag) {
		$self->reset;
	}

	# Return string.
	return $ret;;
}

#------------------------------------------------------------------------------
sub open_tags {
#------------------------------------------------------------------------------
# Return array of opened tags.

	my $self = shift;
	return @{$self->{'printed_tags'}};
}

1;
