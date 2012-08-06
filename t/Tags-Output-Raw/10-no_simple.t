# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 1;

my $obj = Tags::Output::Raw->new(
	'no_simple' => ['tag'],
	'xml' => 1,
);
$obj->put(
	['b', 'tag'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = '<tag></tag>';
is($ret, $right_ret);
