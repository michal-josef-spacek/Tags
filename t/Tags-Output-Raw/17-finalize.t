# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 2;

# Test.
my $obj = Tags::Output::Raw->new;
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
is($ret, '<tag></tag>');

# Test.
$obj = Tags::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
$ret = $obj->flush;
is($ret, '<tag />');
