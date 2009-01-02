print "Testing: Attributes.\n" if $debug;
my $obj = $class->new;
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
ok($ret, $right_ret);
