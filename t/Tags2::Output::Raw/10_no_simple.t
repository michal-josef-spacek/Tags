# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 1;

print "Testing: No simple.\n";
my $obj = Tags2::Output::Raw->new(
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