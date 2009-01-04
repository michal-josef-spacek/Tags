#------------------------------------------------------------------------------
package Tags2::Utils;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY => q{};
Readonly::Array our @EXPORT_OK => qw(encode_newline);
Readonly::Scalar our $VERSION => 0.01;

#------------------------------------------------------------------------------
sub encode_newline {
#------------------------------------------------------------------------------
# Encode newline in data to '\n' in output.

	my $string = shift;
	$string =~ s/\n/\\n/gms;
	return $string;
}

1;
