# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 10;

print "Testing: Simple tag without parameters (sgml version).\n";
my $obj = Tags2::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
is($ret, '<MAIN></MAIN>');

print "Testing: Simple tag with parameters (sgml version).\n";
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id="id_value"></MAIN>');
$obj = Tags2::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id=\'id_value\'></MAIN>');

print "Testing: Simple tag after simple tag (sgml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id="id_value"></MAIN><MAIN id="id_value2"></MAIN>');
$obj = Tags2::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id=\'id_value\'></MAIN><MAIN id=\'id_value2\'></MAIN>');

print "Testing: Simple tag without parameters (xml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main />');

print "Testing: Simple tag with parameters (xml version).\n";
$obj->reset;
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="id_value" />');
$obj = Tags2::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id=\'id_value\' />');

print "Testing: Simple tag after simple tag (xml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
	['b', 'main'],
	['a', 'id', 'id_value2'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="id_value" /><main id="id_value2" />');
$obj = Tags2::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
	['b', 'main'],
	['a', 'id', 'id_value2'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id=\'id_value\' /><main id=\'id_value2\' />');