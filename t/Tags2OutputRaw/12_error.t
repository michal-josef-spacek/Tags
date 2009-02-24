print "Testing: Errors.\n" if $debug;
my $obj = $class->new(
	'xml' => 1,
);
eval {
	$obj->put(['b', 'TAG']);
};
ok($@, "In XML must be lowercase tag name.\n");

$obj->reset;
eval {
	$obj->put(['b', 'tag'], ['b', 'tag2'], ['e', 'tag']);
};
ok($@, "Ending bad tag: 'tag' in block of tag 'tag2'.\n");

$obj->reset;
eval {
	$obj->put(['a', 'key', 'val']);
};
ok($@, 'Bad tag type \'a\'.'."\n");

$obj->reset;
eval {
	$obj->put(['q', 'key', 'val']);
};
ok($@, 'Bad type of data.'."\n");

$obj->reset;
eval {
	$obj->put('q');
};
ok($@, 'Bad data.'."\n");
