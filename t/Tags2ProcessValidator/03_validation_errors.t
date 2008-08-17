# $Id: 03_validation_errors.t,v 1.6 2008-08-17 17:24:40 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Tags2ProcessValidator";

print "Testing: Validation errors.\n" if $debug;
my $obj = $class->new('dtd_file' => "$test_dir/DTD/test3.dtd");
eval {
	$obj->check_one(['b', 'foo']);
};
ok($@, "Tag 'foo' doesn't exist in dtd.\n");

$obj->reset;
eval {
	$obj->check_one(['b', 'CHILD1']);
};
ok($@, "Tag 'CHILD1' cannot be first.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['b', 'MAIN']);
};
ok($@, "Tag 'MAIN' cannot be after other tag.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['b', 'CHILD1']);
eval {
	$obj->check_one(['b', 'CHILD1']);
};
ok($@, "Tag 'CHILD1' cannot be after tag 'CHILD1'.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 1]);
eval {
	$obj->check_one(['a', 'id', 2]);
};
ok($@, "Attribute 'id' at tag 'MAIN' is duplicit.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['a', 'foo', 'bar']);
};
ok($@, "Bad attribute 'foo' at tag 'MAIN'.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['b', 'CHILD1']);
eval {
	$obj->check_one(['a', 'xml:space', 'foo']);
};
ok($@, "Bad value 'foo' of attribute 'xml:space' at tag 'CHILD1'.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['e', 'MAIN']);
};
ok($@, "Missing tag 'CHILD1' at tag 'MAIN'.\n");

$obj = $class->new('dtd_file' => "$test_dir/DTD/test10.dtd");
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['b', 'CHILD1']);
};
ok($@, "Missing required attribute 'id' at tag 'MAIN'.\n");

$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
eval {
	$obj->check_one(['d', 'foo data']);
};
ok($@, "Bad data section in tag 'MAIN'.\n");
