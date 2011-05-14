# Modules.
use Tags2::Output::PYX;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Output::PYX::VERSION, '0.01');
