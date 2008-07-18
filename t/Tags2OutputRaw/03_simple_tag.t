# $Id: 03_simple_tag.t,v 1.5 2008-07-18 13:57:28 skim Exp $

print "Testing: Simple tag without parameters (sgml version).\n" if $debug;
my $obj = $class->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
ok($ret, '<MAIN></MAIN>');

print "Testing: Simple tag with parameters (sgml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
ok($ret, '<MAIN id="id_value"></MAIN>');

print "Testing: Simple tag after simple tag (sgml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
ok($ret, '<MAIN id="id_value"></MAIN><MAIN id="id_value2"></MAIN>');

print "Testing: Simple tag without parameters (xml version).\n" if $debug;
$obj = $class->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['e', 'main'],
);
$ret = $obj->flush;
ok($ret, '<main />');

print "Testing: Simple tag with parameters (xml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
);
$ret = $obj->flush;
ok($ret, '<main id="id_value" />');

print "Testing: Simple tag after simple tag (xml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
	['b', 'main'],
	['a', 'id', 'id_value2'],
	['e', 'main'],
);
$ret = $obj->flush;
ok($ret, '<main id="id_value" /><main id="id_value2" />');
