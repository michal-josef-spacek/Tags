# Modules.
use English qw(-no_match_vars);
use Tags::Process::Id;
use Test::More 'tests' => 3;

# Test.
eval {
	Tags::Process::Id->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

# Test.
eval {
	Tags::Process::Id->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

# Test.
my $obj = Tags::Process::Id->new;
isa_ok($obj, 'Tags::Process::Id');
