# Modules.
use File::Object;
use IO::Scalar;
use Tags::Output::Raw;
use Test::More 'tests' => 5;

print "Testing: 'auto_flush' parameter.\n";
my $obj = Tags::Output::Raw->new(
	'auto_flush' => 1,
	'output_handler' => \*STDOUT,
	'xml' => 1,
);
my $ret;
tie *STDOUT, 'IO::Scalar', \$ret;
$obj->put(
	['b', 'tag'],
	['e', 'tag'],
);
untie *STDOUT;
is($ret, '<tag />');

$obj->reset;
undef $ret;
tie *STDOUT, 'IO::Scalar', \$ret;
$obj->put(['b', 'tag']);
$obj->put(['e', 'tag']);
untie *STDOUT;
is($ret, '<tag />');

$obj->reset;
undef $ret;
tie *STDOUT, 'IO::Scalar', \$ret;
$obj->put(
	['b', 'tag'],
	['d', 'data'],
	['e', 'tag'],
);
untie *STDOUT;
is($ret, '<tag>data</tag>');

$obj->reset;
undef $ret;
tie *STDOUT, 'IO::Scalar', \$ret;
$obj->put(
	['b', 'tag'],
	['b', 'other_tag'],
	['d', 'data'],
	['e', 'other_tag'],
	['e', 'tag'],
);
untie *STDOUT;
is($ret, '<tag><other_tag>data</other_tag></tag>');

$obj->reset;
undef $ret;
tie *STDOUT, 'IO::Scalar', \$ret;
$obj->put(['b', 'tag']);
$obj->put(['b', 'other_tag']);
$obj->put(['d', 'data']);
$obj->put(['e', 'other_tag']);
$obj->put(['e', 'tag']);
untie *STDOUT;
is($ret, '<tag><other_tag>data</other_tag></tag>');
