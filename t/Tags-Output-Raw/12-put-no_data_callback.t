use strict;
use warnings;

use Tags::Output::Raw;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Tags::Output::Raw->new(
	'no_data_callback' => ['element'],
	'xml' => 1,
);
$obj->put(
	['b', 'element'],
	['d', '&'],
	['e', 'element'],
);
my $ret = $obj->flush;
my $right_ret = '<element>&</element>';
is($ret, $right_ret, "Test for element in 'no_data_callback' parameter.");

# Test.
$obj = Tags::Output::Raw->new(
	'no_data_callback' => ['element'],
	'xml' => 1,
);
$obj->put(
	['d', '&'],
);
$ret = $obj->flush;
$right_ret = '&amp;';
is($ret, $right_ret, "Test for only character without element.");
