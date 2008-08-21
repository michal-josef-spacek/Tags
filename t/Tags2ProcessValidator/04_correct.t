# $Id: 04_correct.t,v 1.1 2008-08-21 15:37:12 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Tags2ProcessValidator";

print "Testing: Validation errors.\n" if $debug;
my $obj = $class->new('dtd_file' => "$test_dir/DTD/test1.dtd");
ok($#{$obj->{'printed'}}, -1);
$obj->check_one(['b', 'MAIN']);
ok($obj->{'printed'}->[0], 'MAIN');
$obj->check_one(['b', 'CHILD1']);
ok($obj->{'printed'}->[0], 'CHILD1');
ok($obj->{'printed'}->[1], 'MAIN');
$obj->check_one(['e', 'CHILD1']);
ok($obj->{'printed'}->[0], 'MAIN');
$obj->check_one(['b', 'CHILD1']);
ok($obj->{'printed'}->[0], 'CHILD1');
ok($obj->{'printed'}->[1], 'MAIN');
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed'}}, -1);

$obj = $class->new('dtd_file' => "$test_dir/DTD/test2.dtd");
ok($#{$obj->{'printed'}}, -1);
$obj->check_one(['b', 'MAIN']);
ok($obj->{'printed'}->[0], 'MAIN');
$obj->check_one(['b', 'CHILD1']);
ok($obj->{'printed'}->[0], 'CHILD1');
ok($obj->{'printed'}->[1], 'MAIN');
$obj->check_one(['d', 'data']);
ok($obj->{'printed'}->[0], 'CHILD1');
ok($obj->{'printed'}->[1], 'MAIN');
$obj->check_one(['e', 'CHILD1']);
ok($obj->{'printed'}->[0], 'MAIN');
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed'}}, -1);

$obj->reset;
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['b', 'MAIN']);
ok($obj->{'printed'}->[0], 'MAIN');
$obj->check_one(['a', 'id', 'id']);
ok($obj->{'printed_attr'}->[0], 'id');
$obj->check_one(['b', 'CHILD1']);
ok($obj->{'printed'}->[0], 'CHILD1');
ok($obj->{'printed'}->[1], 'MAIN');
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['d', 'data']);
ok($obj->{'printed'}->[0], 'CHILD1');
ok($obj->{'printed'}->[1], 'MAIN');
$obj->check_one(['e', 'CHILD1']);
ok($obj->{'printed'}->[0], 'MAIN');
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed'}}, -1);

$obj = $class->new('dtd_file' => "$test_dir/DTD/test3.dtd");
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
ok($obj->{'printed_attr'}->[0], 'id');
$obj->check_one(['b', 'CHILD1']);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['b', 'CHILD1']);
$obj->check_one(['d', 'data']);
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['b', 'CHILD1']);
$obj->check_one(['a', 'xml:space', 'preserve']);
ok($obj->{'printed_attr'}->[0], 'xml:space');
$obj->check_one(['b', 'CHILD2']);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['d', 'subdata']);
$obj->check_one(['e', 'CHILD2']);
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['b', 'CHILD1']);
$obj->check_one(['a', 'xml:space', 'default']);
ok($obj->{'printed_attr'}->[0], 'xml:space');
$obj->check_one(['e', 'CHILD1']);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed'}}, -1);

$obj = $class->new('dtd_file' => "$test_dir/DTD/test4.dtd");
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
ok($obj->{'printed_attr'}->[0], 'id');
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed_attr'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);
ok($#{$obj->{'printed'}}, -1);

$obj = $class->new('dtd_file' => "$test_dir/DTD/test5.dtd");
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
$obj->check_one(['d', 'data1', 'data2']);
$obj->check_one(['b', 'CHILD']);
$obj->check_one(['e', 'CHILD']);
$obj->check_one(['d', 'data']);
$obj->check_one(['b', 'CHILD']);
$obj->check_one(['d', 'data']);
$obj->check_one(['e', 'CHILD']);
$obj->check_one(['d', 'data']);
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);

$obj = $class->new('dtd_file' => "$test_dir/DTD/test6.dtd");
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);

$obj->reset;
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id1']);
$obj->check_one(['b', 'CHILD']);
$obj->check_one(['a', 'id', 'id2']);
$obj->check_one(['e', 'CHILD']);
$obj->check_one(['d', 'data']);
$obj->check_one(['b', 'CHILD']);
$obj->check_one(['a', 'id', 'id3']);
$obj->check_one(['d', 'data']);
$obj->check_one(['e', 'CHILD']);
$obj->check_one(['e', 'MAIN']);
ok($#{$obj->{'printed'}}, -1);
ok($#{$obj->{'printed_attr'}}, -1);

# TODO test7.dtd a dalsi.
