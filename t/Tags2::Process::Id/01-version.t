# Modules.
use Tags2::Process::Id;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Process::Id::VERSION, '0.01');
