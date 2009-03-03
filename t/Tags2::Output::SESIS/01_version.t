# Modules.
use Tags2::Output::SESIS;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Output::SESIS::VERSION, '0.02');
