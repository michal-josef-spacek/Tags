# Modules.
use Tags2::Output::PYX;
use Test::More 'tests' => 4;

print "Testing: open_tags() method.\n";
my $obj = Tags2::Output::PYX->new;
my @ret = $obj->open_tags;
is_deeply(\@ret, []);

$obj->put(
	['b', 'tag'],
);
@ret = $obj->open_tags;
is_deeply(\@ret, ['tag']);

$obj->put(
	['b', 'other_tag'],
);
@ret = $obj->open_tags;
is_deeply(\@ret, ['other_tag', 'tag']);

$obj->finalize;
@ret = $obj->open_tags;
is_deeply(\@ret, []);
