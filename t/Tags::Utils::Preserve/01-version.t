# Modules.
use Tags::Utils::Preserve;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags::Utils::Preserve::VERSION, '0.01');
