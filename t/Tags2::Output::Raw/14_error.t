# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 5;

print "Testing: Errors.\n";
my $obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
eval {
	$obj->put(['b', 'TAG']);
};
is($@, "In XML must be lowercase tag name.\n");

$obj->reset;
eval {
	$obj->put(['b', 'tag'], ['b', 'tag2'], ['e', 'tag']);
};
is($@, "Ending bad tag: 'tag' in block of tag 'tag2'.\n");

$obj->reset;
eval {
	$obj->put(['a', 'key', 'val']);
};
is($@, 'Bad tag type \'a\'.'."\n");

$obj->reset;
eval {
	$obj->put(['q', 'key', 'val']);
};
is($@, 'Bad type of data.'."\n");

$obj->reset;
eval {
	$obj->put('q');
};
is($@, 'Bad data.'."\n");
