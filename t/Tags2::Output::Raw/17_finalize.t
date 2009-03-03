# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 2;

print "Testing: finalize() method.\n";
my $obj = Tags2::Output::Raw->new;
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
is($ret, '<tag></tag>');

$obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
$ret = $obj->flush;
is($ret, '<tag />');
