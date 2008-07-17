# $Id: 11_cdata.t,v 1.4 2008-07-17 10:30:09 skim Exp $

print "Testing: CDATA.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
	['cd', 'aaaaa<dddd>dddd'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = "<tag>\n  <![CDATA[aaaaa<dddd>dddd]]>\n</tag>";
ok($ret, $right_ret);

$obj = $class->new(
	'cdata_indent' => 1,
);
$obj->put(
	['b', 'tag'],
	['cd', (('aaaaa<dddd>dddd') x 10)],
	['e', 'tag'], 
);
$ret = $obj->flush;
$right_ret = <<'END';
<tag>
  <![CDATA[aaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>dddd
    aaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>dddd
    aaaaa<dddd>dddd]]>
</tag>
END
chomp $right_ret;
ok($ret, $right_ret);

$obj = $class->new(
	'cdata_indent' => 0,
);
$obj->put(
	['b', 'tag'],
	['cd', (('aaaaa<dddd>dddd') x 10)],
	['e', 'tag'], 
);
$ret = $obj->flush;
$right_ret = <<'END';
<tag>
  <![CDATA[aaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>dddd]]>
</tag>
END
chomp $right_ret;
ok($ret, $right_ret);

print "Testing: CDATA errors.\n" if $debug;
$obj = $class->new;
eval {
	$obj->put(
		['b', 'tag'],
		['cd', 'aaaaa<dddd>dddd', ']]>'],
		['e', 'tag'],
	);
};
ok($@, "Bad CDATA section.\n");
