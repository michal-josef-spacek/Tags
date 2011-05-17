# Modules.
use Test::More 'tests' => 2;

BEGIN {
	print "Usage tests.\n";
	use_ok('Tags::Process::Validator');
}
require_ok('Tags::Process::Validator');
