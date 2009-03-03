# Modules.
use Tags2::Process::Id;
use Test::More 'tests' => 4;

print "Testing: check() method.\n";
my $obj = Tags2::Process::Id->new;
eval {
	$obj->check(
		['b', 'tag'],
		['a', 'id', 'value'],
		['e', 'tag'],
	);
};
is($@, '');

$obj->reset;
eval {
	$obj->check(
		['b', 'tag'],
		['a', 'id', 'value'],
		['a', 'id', 'value2'],
		['e', 'tag'],
	);
};
is($@, "Other id attribute in tag 'tag'.\n");

$obj->reset;
eval {
	$obj->check(
		['b', 'tag'],
		['a', 'id', 'value', 'id', 'value2'],
		['e', 'tag'],
	);
};
is($@, "Other id attribute in tag 'tag'.\n");

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
is($@, "Id attribute 'value' in tag 'tag' is duplicit over structure.\n");
