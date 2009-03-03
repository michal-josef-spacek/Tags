# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 8;

print "Testing: Comment.\n";
my $obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
my $right_ret = '<!--comment--><!-- comment -->';
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['c', 'comment-'],
);
$ret = $obj->flush;
$right_ret = '<!--comment- -->';
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['c', '<tag>comment</tag>'],
);
$ret = $obj->flush;
$right_ret = '<!--<tag>comment</tag>-->';
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag><!--<tag>comment</tag>--></tag>';
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['a', 'par', 'val'],
	['c', '<tag>comment</tag>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag par="val"><!--<tag>comment</tag>--></tag>';
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['a', 'par', 'val'],
	['d', 'data'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<!--<tag>comment</tag>--><tag par="val">data</tag>';
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['a', 'par', 'val'],
	['cd', 'data'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<!--<tag>comment</tag>--><tag par="val"><![CDATA[data]]></tag>';
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['a', 'par', 'val'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<!--<tag>comment</tag>--><tag par="val" />';
is($ret, $right_ret);