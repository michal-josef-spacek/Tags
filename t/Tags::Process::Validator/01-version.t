# Modules.
use Tags::Process::Validator;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags::Process::Validator::VERSION, '0.01');
