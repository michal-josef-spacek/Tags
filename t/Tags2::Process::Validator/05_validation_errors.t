# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Tags2::Process::Validator";

# Modules.
use Tags2::Process::Validator;
use Test::More 'tests' => 9;

print "Testing: Validation errors.\n";
my $obj = Tags2::Process::Validator->new('dtd_file' => "$test_dir/DTD/test3.dtd");
eval {
	$obj->check_one(['b', 'foo']);
};
is($@, "Tag 'foo' doesn't exist in dtd.\n");

$obj->reset;
eval {
	$obj->check_one(['b', 'CHILD1']);
};
is($@, "Tag 'CHILD1' cannot be first.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['b', 'MAIN']);
};
is($@, "Tag 'MAIN' cannot be after other tag.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['b', 'CHILD1']);
eval {
	$obj->check_one(['b', 'CHILD1']);
};
is($@, "Tag 'CHILD1' cannot be after tag 'CHILD1'.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 1]);
eval {
	$obj->check_one(['a', 'id', 2]);
};
is($@, "Attribute 'id' at tag 'MAIN' is duplicit.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['a', 'foo', 'bar']);
};
is($@, "Bad attribute 'foo' at tag 'MAIN'.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['b', 'CHILD1']);
eval {
	$obj->check_one(['a', 'xml:space', 'foo']);
};
is($@, "Bad value 'foo' of attribute 'xml:space' at tag 'CHILD1'.\n");

# TODO Pro zatim neni implementovano.
#$obj->reset;
#$obj->check_one(['b', 'MAIN']);
#eval {
#	$obj->check_one(['e', 'MAIN']);
#};
#is($@, "Missing tag 'CHILD1' at tag 'MAIN'.\n");

$obj = Tags2::Process::Validator->new('dtd_file' => "$test_dir/DTD/test10.dtd");
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['b', 'CHILD1']);
};
is($@, "Missing required attribute 'id' at tag 'MAIN'.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
eval {
	$obj->check_one(['d', 'foo data']);
};
is($@, "Bad data section in tag 'MAIN'.\n");