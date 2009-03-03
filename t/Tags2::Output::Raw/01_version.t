# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Output::Raw::VERSION, '0.06');
