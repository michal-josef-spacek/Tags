# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 3;

print "Testing: Instruction.\n";
my $obj = Tags2::Output::Raw->new;
$obj->put(
	['i', 'perl', 'print "1\n";'],
);
my $ret = $obj->flush;
is($ret, '<?perl print "1\n";?>');

$obj->reset;
$obj->put(
	['i', 'perl'],
);
$ret = $obj->flush;
is($ret, '<?perl?>');

$obj->reset;
$obj->put(
	['b', 'tag'],
	['i', 'perl', 'print "1\n";'],
	['e', 'tag'],
);
$ret = $obj->flush;
is($ret, '<tag><?perl print "1\n";?></tag>');
