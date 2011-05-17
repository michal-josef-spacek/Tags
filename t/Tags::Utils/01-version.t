# Modules.
use Tags::Utils;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags::Utils::VERSION, '0.01');
