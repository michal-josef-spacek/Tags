# Modules.
use Tags2::Output::LibXML;
use Test::More 'tests' => 3;

print "Testing: CDATA.\n";
my $obj = Tags2::Output::LibXML->new;
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
is($ret, $right_ret);

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
is($ret, $right_ret);

print "Testing: CDATA errors.\n";
$obj = Tags2::Output::LibXML->new;
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
is($ret, $right_ret);
