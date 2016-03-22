# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 5;
use Test::NoWarnings;

# Test.
my $obj = Tags::Output::Raw->new;
my @ret = $obj->open_tags;
is_deeply(\@ret, []);

$obj->put(
	['b', 'element'],
);
@ret = $obj->open_tags;
is_deeply(\@ret, ['element']);

# Test.
$obj->put(
	['b', 'other_element'],
);
@ret = $obj->open_tags;
is_deeply(\@ret, ['other_element', 'element']);

# Test.
$obj->finalize;
@ret = $obj->open_tags;
is_deeply(\@ret, []);
