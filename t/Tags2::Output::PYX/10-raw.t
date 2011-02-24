# Modules.
use Tags2::Output::PYX;
use Test::More 'tests' => 1;

print "Testing: Raw data.\n";
my $obj = Tags2::Output::PYX->new;
$obj->put(
	['r', '<?xml version="1.1"?>'."\n"],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
-<?xml version="1.1"?>\n
END
chomp $right_ret;
is($ret, $right_ret);
