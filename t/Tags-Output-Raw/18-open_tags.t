# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 4;

# Test.
my $obj = Tags::Output::Raw->new;
my @ret = $obj->open_tags;
is_deeply(\@ret, []);

$obj->put(
	['b', 'tag'],
);
@ret = $obj->open_tags;
is_deeply(\@ret, ['tag']);

# Test.
$obj->put(
	['b', 'other_tag'],
);
@ret = $obj->open_tags;
is_deeply(\@ret, ['other_tag', 'tag']);

# Test.
$obj->finalize;
@ret = $obj->open_tags;
is_deeply(\@ret, []);
