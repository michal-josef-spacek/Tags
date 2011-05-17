# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 2;

print "Testing: finalize() method.\n";
my $obj = Tags::Output::Raw->new;
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
is($ret, '<tag></tag>');

$obj = Tags::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
$ret = $obj->flush;
is($ret, '<tag />');
