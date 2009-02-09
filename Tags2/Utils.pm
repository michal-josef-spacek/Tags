#------------------------------------------------------------------------------
package Tags2::Utils;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;
use HTML::Entities;

# Constants.
Readonly::Array our @EXPORT_OK => qw(encode_newline encode_base_entities);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub encode_newline {
#------------------------------------------------------------------------------
# Encode newline in data to '\n' in output.

	my $string = shift;
	$string =~ s/\n/\\n/gms;
	return $string;
}

#------------------------------------------------------------------------------
sub encode_base_entities {
#------------------------------------------------------------------------------
# Encode '<>&' base entities.

	my $data = shift;
	if (ref $data eq 'SCALAR') {
		${$data} = encode_entities(${$data}, '<>&');
		return;
	} else {
		return encode_entities($data, '<>&');
	}
}

1;
