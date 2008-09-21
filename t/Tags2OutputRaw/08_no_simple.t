print "Testing: No simple.\n" if $debug;
my $obj = $class->new(
	'no_simple' => ['tag'],
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = '<tag></tag>';
ok($ret, $right_ret);

