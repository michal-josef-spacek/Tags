# $Id: 11_cdata.t,v 1.1 2008-04-18 17:25:21 skim Exp $

print "Testing: CDATA.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
	['cd', 'aaaaa<dddd>dddd'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = '<tag><![CDATA[aaaaa<dddd>dddd]]></tag>';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['cd', 'aaaaa<dddd>dddd', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
# TODO Error.
$right_ret = '<tag><![CDATA[aaaaa<dddd>dddd]]></tag>';
ok($ret, $right_ret);

