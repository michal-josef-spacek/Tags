# $Id: 10_raw.t,v 1.4 2008-07-17 10:58:46 skim Exp $

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
# TODO
#ok($ret, $right_ret);

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
# TODO
#ok($ret, $right_ret);

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
$right_ret = "<tag key=\"val\">\n  <![CDATA[<other>bla</other>]]>\n</tag>";
# TODO
#ok($ret, $right_ret);
