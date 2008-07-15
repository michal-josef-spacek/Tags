# $Id: 11_cdata.t,v 1.2 2008-07-15 09:31:14 skim Exp $

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
eval {
	$obj->put(
		['b', 'tag'],
		['cd', 'aaaaa<dddd>dddd', ']]>'],
		['e', 'tag'],
	);
};
ok($@, "Bad CDATA section.\n");
