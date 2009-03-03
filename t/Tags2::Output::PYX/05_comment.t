# Modules.
use Tags2::Output::PYX;
use Test::More 'tests' => 1;

print "Testing: Comment.\n";
my $obj = Tags2::Output::PYX->new;
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
is($ret, '');
