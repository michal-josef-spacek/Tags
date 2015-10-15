# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 3;

# Test.
my $obj = Tags::Output::Raw->new;
$obj->put(
	['i', 'perl', 'print "1\n";'],
);
my $ret = $obj->flush;
is($ret, '<?perl print "1\n";?>');

# Test.
$obj->reset;
$obj->put(
	['i', 'perl'],
);
$ret = $obj->flush;
is($ret, '<?perl?>');

# Test.
$obj->reset;
$obj->put(
	['b', 'tag'],
	['i', 'perl', 'print "1\n";'],
	['e', 'tag'],
);
$ret = $obj->flush;
is($ret, '<tag><?perl print "1\n";?></tag>');
