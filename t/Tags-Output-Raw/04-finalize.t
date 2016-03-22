# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Tags::Output::Raw->new;
$obj->put(
	['b', 'element'],
);
$obj->finalize;
my $ret = $obj->flush;
is($ret, '<element></element>');

# Test.
$obj = Tags::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'element'],
);
$obj->finalize;
$ret = $obj->flush;
is($ret, '<element />');
