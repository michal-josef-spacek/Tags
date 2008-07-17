# $Id: 09_raw.t,v 1.3 2008-07-17 10:25:36 skim Exp $

print "Testing: Raw.\n" if $debug;
my $obj = $class->new(
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
	['r', '<![CDATA['],
	['d', 'bla'],
	['r', ']]>'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = '<tag><![CDATA[bla]]></tag>';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['a', 'key', 'val'],
	['r', '<![CDATA['],
	['d', 'bla'],
	['r', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag key="val"><![CDATA[bla]]></tag>';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['a', 'key', 'val'],
	['r', '<![CDATA['],
	['b', 'other'],
	['d', 'bla'],
	['e', 'other'],
	['r', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag key="val"><![CDATA[<other>bla</other>]]></tag>';
ok($ret, $right_ret);
