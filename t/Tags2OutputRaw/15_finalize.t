print "Testing: finalize() method.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
ok($ret, '<tag></tag>');

$obj = $class->new(
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
$ret = $obj->flush;
ok($ret, '<tag />');
