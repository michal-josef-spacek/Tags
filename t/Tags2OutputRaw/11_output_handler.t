# $Id: 11_output_handler.t,v 1.1 2008-07-17 10:29:24 skim Exp $

print "Testing: Output handler.\n" if $debug;
my $obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 0,
);
my $ret = go($obj, 1, ['b', 'MAIN'], ['d', 'data'], ['e', 'MAIN']);
ok($ret, '<MAIN>data</MAIN>');
