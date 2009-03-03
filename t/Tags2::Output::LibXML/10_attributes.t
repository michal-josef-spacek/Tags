# Modules.
use Tags2::Output::LibXML;
use Test::More 'tests' => 1;

print "Testing: Attributes.\n";
my $obj = Tags2::Output::LibXML->new;
$obj->put(
	['b', 'foo'],
	['a', 'one', '...........................'],
	['a', 'two', '...........................'],
	['a', 'three', '.........................'],
	['e', 'foo'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<foo one="..........................." two="..........................." three="........................."/>
END
is($ret, $right_ret);
