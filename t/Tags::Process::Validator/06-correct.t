# Modules.
use File::Object;
use Tags::Process::Validator;
use Test::More 'tests' => 47;

# Directories.
my $dtd_dir = File::Object->new->up->dir('dtd');

# Test.
my $obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('test1.dtd')->s,
);
is_deeply(
	$obj->{'printed'},
	[],
);
$obj->check_one(['b', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	['MAIN'],
);
$obj->check_one(['b', 'CHILD1']);
is_deeply(
	$obj->{'printed'},
	['CHILD1', 'MAIN'],
);
$obj->check_one(['e', 'CHILD1']);
is_deeply(
	$obj->{'printed'},
	['MAIN'],
);
$obj->check_one(['b', 'CHILD1']);
is_deeply(
	$obj->{'printed'},
	['CHILD1', 'MAIN'],
);
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['e', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	[],
);

# Test.
$obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->('test2.dtd')->s,
);
is_deeply(
	$obj->{'printed'},
	[],
);
$obj->check_one(['b', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	['MAIN'],
);
$obj->check_one(['b', 'CHILD1']);
is_deeply(
	$obj->{'printed'},
	['CHILD1', 'MAIN'],
);
$obj->check_one(['d', 'data']);
is_deeply(
	$obj->{'printed'},
	['CHILD1', 'MAIN'],
);
$obj->check_one(['e', 'CHILD1']);
is_deeply(
	$obj->{'printed'},
	['MAIN'],
);
$obj->check_one(['e', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	[],
);

# Test.
$obj->reset;
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['b', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	['MAIN'],
);
$obj->check_one(['a', 'id', 'id']);
is_deeply(
	$obj->{'printed_attr'},
	['id'],
);
$obj->check_one(['b', 'CHILD1']);
is_deeply(
	$obj->{'printed'},
	['CHILD1', 'MAIN'],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['d', 'data']);
is_deeply(
	$obj->{'printed'},
	['CHILD1', 'MAIN'],
);
$obj->check_one(['e', 'CHILD1']);
is_deeply(
	$obj->{'printed'},
	['MAIN'],
);
$obj->check_one(['e', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	[],
);

# Test.
$obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('test3.dtd')->s,
);
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
is_deeply(
	$obj->{'printed_attr'},
	['id'],
);
$obj->check_one(['b', 'CHILD1']);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['b', 'CHILD1']);
$obj->check_one(['d', 'data']);
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['b', 'CHILD1']);
$obj->check_one(['a', 'xml:space', 'preserve']);
is_deeply(
	$obj->{'printed_attr'},
	['xml:space'],
);
$obj->check_one(['b', 'CHILD2']);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['d', 'subdata']);
$obj->check_one(['e', 'CHILD2']);
$obj->check_one(['e', 'CHILD1']);
$obj->check_one(['b', 'CHILD1']);
$obj->check_one(['a', 'xml:space', 'default']);
is_deeply(
	$obj->{'printed_attr'},
	['xml:space'],
);
$obj->check_one(['e', 'CHILD1']);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['e', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	[],
);

# Test.
$obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('test4.dtd')->s,
);
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['a', 'id', 'id']);
is_deeply(
	$obj->{'printed_attr'},
	['id'],
);
$obj->check_one(['e', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);

# Test.
$obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('test5.dtd')->s,
);
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
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
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);

# Test.
$obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->('test6.dtd')->s,
);
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
$obj->check_one(['b', 'MAIN']);
$obj->check_one(['e', 'MAIN']);
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);

# Test.
$obj->reset;
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);
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
is_deeply(
	$obj->{'printed'},
	[],
);
is_deeply(
	$obj->{'printed_attr'},
	[],
);

# TODO test7.dtd a dalsi.
