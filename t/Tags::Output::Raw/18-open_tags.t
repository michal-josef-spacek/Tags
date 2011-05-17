# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 4;

my $obj = Tags::Output::Raw->new;
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
