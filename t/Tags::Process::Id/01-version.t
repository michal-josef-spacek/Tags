# Modules.
use Tags::Process::Id;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags::Process::Id::VERSION, '0.01');
