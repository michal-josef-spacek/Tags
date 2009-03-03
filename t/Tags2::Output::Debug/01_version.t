# Modules.
use Tags2::Output::Debug;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Output::Debug::VERSION, '0.01');
