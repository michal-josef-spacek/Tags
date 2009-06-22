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
my $right_ret = <<'END';
-<!--comment-->
-<!-- comment -->
END
chomp $right_ret;
is($ret, $right_ret);
