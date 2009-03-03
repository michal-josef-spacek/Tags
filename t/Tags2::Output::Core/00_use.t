# Modules.
use Test::More 'tests' => 2;

BEGIN {
	print "Usage tests.\n";
	use_ok('Tags2::Output::Core');
}
require_ok('Tags2::Output::Core');
