# $Id: 10_raw.t,v 1.2 2008-04-18 17:04:59 skim Exp $

print "Testing: Raw.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
	['r', '<![CDATA['],
	['d', 'bla'],
	['r', ']]>'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = "<tag>\n  <![CDATA[bla]]>\n</tag>";
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
$right_ret = "<tag key=\"val\">\n  <![CDATA[bla]]>\n</tag>";
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
$right_ret = '<tag key="val">\n  <![CDATA[<other>bla</other>]]>\n</tag>';
ok($ret, $right_ret);
