# $Id: 07_comment.t,v 1.4 2007-09-20 17:26:55 skim Exp $

print "Testing: Comment.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
my $right_ret = '<!--comment--><!-- comment -->';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['c', 'comment-'],
);
$ret = $obj->flush;
$right_ret = '<!--comment- -->';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['c', '<tag>comment</tag>'],
);
$ret = $obj->flush;
$right_ret = '<!--<tag>comment</tag>-->';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag><!--<tag>comment</tag>--></tag>';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['a', 'par', 'val'],
	['c', '<tag>comment</tag>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag par="val"><!--<tag>comment</tag>--></tag>';
ok($ret, $right_ret);

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
ok($ret, $right_ret);

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
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['a', 'par', 'val'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<!--<tag>comment</tag>--><tag par="val" />';
ok($ret, $right_ret);
