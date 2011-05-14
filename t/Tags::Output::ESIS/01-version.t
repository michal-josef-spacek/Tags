# Modules.
use Tags2::Output::ESIS;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Output::ESIS::VERSION, '0.02');
