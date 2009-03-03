# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 1;

print "Testing: 'skip_bad_tags' parameter.\n";
my $obj = Tags2::Output::Raw->new(
	'skip_bad_tags' => 1,
);
$obj->put(
	['b', 'tag'],
	['q', 'tag'],
	['e', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
is($ret, '<tag></tag>');
