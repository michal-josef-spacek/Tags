# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 2;

print "Testing: CDATA.\n";
my $obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
	['cd', 'aaaaa<dddd>dddd'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = '<tag><![CDATA[aaaaa<dddd>dddd]]></tag>';
is($ret, $right_ret);

$obj->reset;
eval {
	$obj->put(
		['b', 'tag'],
		['cd', 'aaaaa<dddd>dddd', ']]>'],
		['e', 'tag'],
	);
};
is($@, "Bad CDATA data.\n");
