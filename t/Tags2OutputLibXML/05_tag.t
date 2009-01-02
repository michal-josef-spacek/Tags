print "Testing: Normal tag without parameters.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN>data</MAIN>
END
ok($ret, $right_ret);

print "Testing: Normal tag with parameters.\n" if $debug;
$obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN id="id_value">data</MAIN>
END
ok($ret, $right_ret);
