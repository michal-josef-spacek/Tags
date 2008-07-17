# $Id: 10_cdata.t,v 1.3 2008-07-17 10:25:36 skim Exp $

print "Testing: CDATA.\n" if $debug;
my $obj = $class->new(
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
	['cd', 'aaaaa<dddd>dddd'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = '<tag><![CDATA[aaaaa<dddd>dddd]]></tag>';
ok($ret, $right_ret);

$obj->reset;
eval {
	$obj->put(
		['b', 'tag'],
		['cd', 'aaaaa<dddd>dddd', ']]>'],
		['e', 'tag'],
	);
};
ok($@, "Bad CDATA data.\n");
