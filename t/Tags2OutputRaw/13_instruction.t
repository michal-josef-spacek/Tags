print "Testing: Instruction.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['i', 'perl', 'print "1\n";'],
);
my $ret = $obj->flush;
ok($ret, '<?perl print "1\n";?>');

$obj->reset;
$obj->put(
	['i', 'perl'],
);
$ret = $obj->flush;
ok($ret, '<?perl?>');

$obj->reset;
$obj->put(
	['b', 'tag'],
	['i', 'perl', 'print "1\n";'],
	['e', 'tag'],
);
$ret = $obj->flush;
ok($ret, '<tag><?perl print "1\n";?></tag>');
