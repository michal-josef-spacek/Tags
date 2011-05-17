# Modules.
use English qw(-no_match_vars);
use Tags::Process::Id;
use Test::More 'tests' => 4;

print "Testing: check() method.\n";
my $obj = Tags::Process::Id->new;
eval {
	$obj->check(
		['b', 'tag'],
		['a', 'id', 'value'],
		['e', 'tag'],
	);
};
is($EVAL_ERROR, '');

$obj->reset;
eval {
	$obj->check(
		['b', 'tag'],
		['a', 'id', 'value'],
		['a', 'id', 'value2'],
		['e', 'tag'],
	);
};
is($EVAL_ERROR, "Other id attribute in tag 'tag'.\n");

$obj->reset;
eval {
	$obj->check(
		['b', 'tag'],
		['a', 'id', 'value', 'id', 'value2'],
		['e', 'tag'],
	);
};
is($EVAL_ERROR, "Other id attribute in tag 'tag'.\n");

$obj->reset;
eval {
	$obj->check(
		['b', 'tag'],
		['a', 'id', 'value'],
		['e', 'tag'],
		['b', 'tag'],
		['a', 'id', 'value'],
		['e', 'tag'],
	);
};
is($EVAL_ERROR, "Id attribute 'value' in tag 'tag' is duplicit over structure.\n");
