print "Testing: Tags combination.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['c', ' COMMENT '],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['d', 'DATA'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = "<MAIN>\n  <!-- COMMENT -->\n</MAIN>\n<MAIN>\n  DATA\n</MAIN>";
ok($ret, $right_ret);
