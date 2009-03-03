# Modules.
use Tags2::Output::Core;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Output::Core::VERSION, '0.02');
