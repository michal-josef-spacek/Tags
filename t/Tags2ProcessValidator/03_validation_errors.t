# $Id: 03_validation_errors.t,v 1.2 2008-08-16 22:22:17 skim Exp $

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

# TODO
Check to attributes.
