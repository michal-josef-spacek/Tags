# Modules.
use English qw(-no_match_vars);
use Tags::Process::Id;
use Test::More 'tests' => 3;

eval {
	Tags::Process::Id->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

eval {
	Tags::Process::Id->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

my $obj = Tags::Process::Id->new;
isa_ok($obj, 'Tags::Process::Id');
