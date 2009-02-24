print "Testing: finalize() method.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
ok($ret, '<tag></tag>');
