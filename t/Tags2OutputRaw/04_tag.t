# $Id: 04_tag.t,v 1.2 2007-09-12 02:43:19 skim Exp $

print "Testing: Normal tag without parameters.\n" if $debug;
my $obj = $class->new(
	'output_handler' => *STDOUT,
);
my $ret = go($obj, 1, ['b', 'MAIN'], ['d', 'data'], ['e', 'MAIN']);
ok($ret, '<MAIN>data</MAIN>');

print "Testing: Normal tag with parameters.\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
);
$ret = go($obj, 1, ['b', 'MAIN'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'MAIN']);
ok($ret, '<MAIN id="id_value">data</MAIN>');

print "Testing: Normal tag after normal tag.\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
);
$ret = go($obj, 1, ['b', 'MAIN'], ['a', 'id', 'id_value'], ['d', 'data'], 
	['e', 'MAIN'], ['b', 'MAIN'], ['a', 'id', 'id_value2'], 
	['d', 'data'], ['e', 'MAIN']);
ok($ret, '<MAIN id="id_value">data</MAIN><MAIN id="id_value2">data</MAIN>');
