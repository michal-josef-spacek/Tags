print "Testing: Comment.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
ok($ret, '');
