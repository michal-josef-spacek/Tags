# Modules.
use Tags2::Process::Validator;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Process::Validator::VERSION, '0.01');
