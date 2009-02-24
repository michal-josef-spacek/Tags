print "Testing: open_tags() method.\n" if $debug;
my $obj = $class->new;
my @ret = $obj->open_tags;
ok(scalar @ret, 0);

$obj->put(
	['b', 'tag'],
);
@ret = $obj->open_tags;
ok(scalar @ret, 1);
ok($ret[0], 'tag');

$obj->put(
	['b', 'other_tag'],
);
@ret = $obj->open_tags;
ok(scalar @ret, 2);
ok($ret[0], 'other_tag');
ok($ret[1], 'tag');

$obj->finalize;
@ret = $obj->open_tags;
ok(scalar @ret, 0);
