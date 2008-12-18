# TODO TODO TODO
# Odzkouset pomoci XML::LibXML::Document samotny dokument s komentarem. Pripadne
# dva root tagy apod.

print "Testing: Comment.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
my $right_ret = "<!--comment-->\n<!-- comment -->";
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
$right_ret = "<tag>\n  <!--<tag>comment</tag>-->\n</tag>";
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['a', 'par', 'val'],
	['c', '<tag>comment</tag>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag par="val">'."\n  <!--<tag>comment</tag>-->\n</tag>";
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
$right_ret = "<!--<tag>comment</tag>-->\n<tag par=\"val\">\n  data\n</tag>";
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'oo'],
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['a', 'par', 'val'],
	['d', 'data'],
	['e', 'tag'],
	['e', 'oo'],
);
$ret = $obj->flush;
$right_ret = "<oo>\n  <!--<tag>comment</tag>-->\n  <tag par=\"val\">\n    ".
	"data\n  </tag>\n</oo>";
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
$right_ret = "<!--<tag>comment</tag>-->\n<tag par=\"val\">\n  <![CDATA[data]]>\n</tag>";
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['c', '<tag>comment</tag>'],
	['a', 'par', 'val'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = "<!--<tag>comment</tag>-->\n<tag par=\"val\" />";
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag1'],
	['b', 'tag2'],
	['c', ' comment '],
	['e', 'tag2'],
	['e', 'tag1'],
);
$ret = $obj->flush;
$right_ret = "<tag1>\n  <tag2>\n    <!-- comment -->\n  </tag2>\n</tag1>";
ok($ret, $right_ret);
