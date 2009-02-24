print "Testing: 'skip_bad_tags' parameter.\n" if $debug;
my $obj = $class->new(
	'skip_bad_tags' => 1,
);
$obj->put(
	['b', 'tag'],
	['q', 'tag'],
	['e', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
ok($ret, '<tag></tag>');
