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
