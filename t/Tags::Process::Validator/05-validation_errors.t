# Modules.
use English qw(-no_match_vars);
use File::Object;
use Tags::Process::Validator;
use Test::More 'tests' => 9;

# Directories.
my $dtd_dir = File::Object->new->up->dir('dtd');

# Test.
my $obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('test3.dtd')->s,
);
eval {
	$obj->check_one(['b', 'foo']);
};
is($EVAL_ERROR, "Tag 'foo' doesn't exist in dtd.\n");

# Test.
$obj->reset;
eval {
	$obj->check_one(['b', 'CHILD1']);
};
is($EVAL_ERROR, "Tag 'CHILD1' cannot be first.\n");

# Test.
$obj->reset;
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['b', 'MAIN']);
};
is($EVAL_ERROR, "Tag 'MAIN' cannot be after other tag.\n");

# Test.
$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['b', 'CHILD1']);
eval {
	$obj->check_one(['b', 'CHILD1']);
};
is($EVAL_ERROR, "Tag 'CHILD1' cannot be after tag 'CHILD1'.\n");

# Test.
$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 1]);
eval {
	$obj->check_one(['a', 'id', 2]);
};
is($EVAL_ERROR, "Attribute 'id' at tag 'MAIN' is duplicit.\n");

# Test.
$obj->reset;
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['a', 'foo', 'bar']);
};
is($EVAL_ERROR, "Bad attribute 'foo' at tag 'MAIN'.\n");

# Test.
$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['b', 'CHILD1']);
eval {
	$obj->check_one(['a', 'xml:space', 'foo']);
};
is($EVAL_ERROR, "Bad value 'foo' of attribute 'xml:space' at tag 'CHILD1'.\n");

# Test.
# TODO Pro zatim neni implementovano.
#$obj->reset;
#$obj->check_one(['b', 'MAIN']);
#eval {
#	$obj->check_one(['e', 'MAIN']);
#};
#is($EVAL_ERROR, "Missing tag 'CHILD1' at tag 'MAIN'.\n");

# Test.
$obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('test10.dtd')->s,
);
$obj->check_one(['b', 'MAIN']);
eval {
	$obj->check_one(['b', 'CHILD1']);
};
is($EVAL_ERROR, "Missing required attribute 'id' at tag 'MAIN'.\n");

# Test.
$obj->reset;
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
eval {
	$obj->check_one(['d', 'foo data']);
};
is($EVAL_ERROR, "Bad data section in tag 'MAIN'.\n");
