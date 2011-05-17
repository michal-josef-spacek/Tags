# Pragmas.
use strict;
use warnings;

# Modules.
use Test::More 'tests' => 2;

BEGIN {

	# Test.
	use_ok('Tags::Process::Id');
}

# Test.
require_ok('Tags::Process::Id');
