# Modules.
use Test::More 'tests' => 2;

BEGIN {
	print "Usage tests.\n";
	use_ok('Tags::Utils::Preserve');
}
require_ok('Tags::Utils::Preserve');
