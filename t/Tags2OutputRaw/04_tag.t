# $Id: 04_tag.t,v 1.4 2008-07-17 10:29:38 skim Exp $

print "Testing: Normal tag without parameters (sgml version).\n" if $debug;
my $obj = $class->new(
	'xml' => 0,
);
$obj->put(['b', 'MAIN'], ['d', 'data'], ['e', 'MAIN']);
my $ret = $obj->flush;
ok($ret, '<MAIN>data</MAIN>');

print "Testing: Normal tag with parameters (sgml version).\n" if $debug;
$obj = $class->new(
	'xml' => 0,
);
$obj->put(['b', 'MAIN'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'MAIN']);
$ret = $obj->flush;
ok($ret, '<MAIN id="id_value">data</MAIN>');

print "Testing: Normal tag after normal tag (sgml version).\n" if $debug;
$obj = $class->new(
	'xml' => 0,
);
$obj->put(['b', 'MAIN'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'MAIN'], ['b', 'MAIN'], ['a', 'id', 'id_value2'], 
	['d', 'data'], ['e', 'MAIN']);
$ret = $obj->flush;
ok($ret, '<MAIN id="id_value">data</MAIN><MAIN id="id_value2">data</MAIN>');

print "Testing: Normal tag without parameters (xml version).\n" if $debug;
$obj = $class->new(
	'xml' => 1,
);
$obj->put(['b', 'main'], ['d', 'data'], ['e', 'main']);
$ret = $obj->flush;
ok($ret, '<main>data</main>');

print "Testing: Normal tag with parameters (xml version).\n" if $debug;
$obj = $class->new(
	'xml' => 1,
);
$obj->put(['b', 'main'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'main']);
$ret = $obj->flush;
ok($ret, '<main id="id_value">data</main>');

print "Testing: Normal tag after normal tag (xml version).\n" if $debug;
$obj = $class->new(
	'xml' => 1,
);
$obj->put(['b', 'main'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'main'], ['b', 'main'], ['a', 'id', 'id_value2'], 
	['d', 'data'], ['e', 'main']);
$ret = $obj->flush;
ok($ret, '<main id="id_value">data</main><main id="id_value2">data</main>');
