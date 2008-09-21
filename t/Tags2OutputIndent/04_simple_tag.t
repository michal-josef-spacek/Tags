print "Testing: Simple tag without parameters.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
ok($ret, '<MAIN />');

print "Testing: Simple tag with parameters.\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
ok($ret, '<MAIN id="id_value" />');

print "Testing: Simple tag after simple tag.\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN']
);
$ret = $obj->flush;
ok($ret, "<MAIN id=\"id_value\" />\n<MAIN id=\"id_value2\" />");
