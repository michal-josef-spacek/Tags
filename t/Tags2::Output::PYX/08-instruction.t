# Modules.
use Tags2::Output::PYX;
use Test::More 'tests' => 1;

print "Testing: Instruction.\n";
my $obj = Tags2::Output::PYX->new;
$obj->put(
	['i', 'perl'],
	['i', 'perl', 'print "1";'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
?perl
?perl print "1";
END
chomp $right_ret;
is($ret, $right_ret);
