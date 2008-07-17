# $Id: 04_tag.t,v 1.3 2008-07-17 10:20:34 skim Exp $

print "Testing: Normal tag without parameters (sgml version).\n" if $debug;
my $obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 0,
);
my $ret = go($obj, 1, ['b', 'MAIN'], ['d', 'data'], ['e', 'MAIN']);
ok($ret, '<MAIN>data</MAIN>');

print "Testing: Normal tag with parameters (sgml version).\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 0,
);
$ret = go($obj, 1, ['b', 'MAIN'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'MAIN']);
ok($ret, '<MAIN id="id_value">data</MAIN>');

print "Testing: Normal tag after normal tag (sgml version).\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 0,
);
$ret = go($obj, 1, ['b', 'MAIN'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'MAIN'], ['b', 'MAIN'], ['a', 'id', 'id_value2'], 
	['d', 'data'], ['e', 'MAIN']);
ok($ret, '<MAIN id="id_value">data</MAIN><MAIN id="id_value2">data</MAIN>');

print "Testing: Normal tag without parameters (xml version).\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 1,
);
$ret = go($obj, 1, ['b', 'main'], ['d', 'data'], ['e', 'main']);
ok($ret, '<main>data</main>');

print "Testing: Normal tag with parameters (xml version).\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 1,
);
$ret = go($obj, 1, ['b', 'main'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'main']);
ok($ret, '<main id="id_value">data</main>');

print "Testing: Normal tag after normal tag (xml version).\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 1,
);
$ret = go($obj, 1, ['b', 'main'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'main'], ['b', 'main'], ['a', 'id', 'id_value2'], 
	['d', 'data'], ['e', 'main']);
ok($ret, '<main id="id_value">data</main><main id="id_value2">data</main>');
