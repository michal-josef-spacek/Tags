# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags::Output::Raw::VERSION, '0.06');
