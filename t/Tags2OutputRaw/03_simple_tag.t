# $Id: 03_simple_tag.t,v 1.2 2007-09-12 02:43:19 skim Exp $

print "Testing: Simple tag without parameters.\n" if $debug;
my $obj = $class->new(
	'output_handler' => *STDOUT,
);
my $ret = go($obj, 1, ['b', 'MAIN'], ['e', 'MAIN']);
ok($ret, '<MAIN />');

print "Testing: Simple tag with parameters.\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
);
$ret = go($obj, 1, ['b', 'MAIN'], ['a', 'id', 'id_value'], ['e', 'MAIN']);
ok($ret, '<MAIN id="id_value" />');

print "Testing: Simple tag after simple tag.\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
);
$ret = go($obj, 1, ['b', 'MAIN'], ['a', 'id', 'id_value'], ['e', 'MAIN'], 
	['b', 'MAIN'], ['a', 'id', 'id_value2'], ['e', 'MAIN']);
ok($ret, '<MAIN id="id_value" /><MAIN id="id_value2" />');
