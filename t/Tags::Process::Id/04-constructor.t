# Modules.
use English qw(-no_match_vars);
use Tags::Process::Id;
use Test::More 'tests' => 4;

print "Testing: new('') bad constructor.\n";
my $obj;
eval {
	$obj = Tags::Process::Id->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n";
eval {
	$obj = Tags::Process::Id->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

print "Testing: new() right constructor.\n";
eval {
	$obj = Tags::Process::Id->new;
};
ok(defined $obj);
ok($obj->isa('Tags::Process::Id'));
