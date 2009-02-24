print "Testing: Output handler.\n" if $debug;
my $obj = $class->new(
	'output_handler' => \*STDOUT,
	'xml' => 0,
);
my $ret = go($obj, 1, ['b', 'MAIN'], ['d', 'data'], ['e', 'MAIN']);
ok($ret, '<MAIN>data</MAIN>');

$obj = $class->new(
	'auto_flush' => 1,
	'output_handler' => \*STDOUT,
	'xml' => 0,
);
$ret = go($obj, 1, ['b', 'MAIN'], ['d', 'data'], ['e', 'MAIN']);
ok($ret, '<MAIN>data</MAIN>');
