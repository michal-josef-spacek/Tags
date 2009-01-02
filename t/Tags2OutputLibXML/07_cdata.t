print "Testing: CDATA.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
	['cd', 'aaaaa<dddd>dddd'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<tag><![CDATA[aaaaa<dddd>dddd]]></tag>
END
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['cd', (('aaaaa<dddd>dddd') x 10)],
	['e', 'tag'], 
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<tag><![CDATA[aaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>ddddaaaaa<dddd>dddd]]></tag>
END
ok($ret, $right_ret);

print "Testing: CDATA errors.\n" if $debug;
$obj = $class->new;
$obj->put(
	['b', 'tag'],
	['cd', 'aaaaa<dddd>dddd', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<tag><![CDATA[aaaaa<dddd>dddd]]]]><![CDATA[>]]></tag>
END
ok($ret, $right_ret);
