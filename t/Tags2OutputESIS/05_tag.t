print "Testing: Normal tag without parameters.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
(MAIN
-data
)MAIN
END
chomp $right_ret;
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
Aid id_value
(MAIN
-data
)MAIN
END
chomp $right_ret;
ok($ret, $right_ret);

print "Testing: Normal tag after normal tag.\n" if $debug;
$obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['d', 'data'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
Aid id_value
(MAIN
-data
)MAIN
Aid id_value2
(MAIN
-data
)MAIN
END
chomp $right_ret;
ok($ret, $right_ret);

print "Testing: Normal tag with long data.\n" if $debug;
my $long_data = 'a' x 1000;
$obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
(MAIN
-$long_data
)MAIN
END
chomp $right_ret;
ok($ret, $right_ret);

$long_data = 'aaaa ' x 1000;
$obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
(MAIN
-$long_data
)MAIN
END
chomp $right_ret;
ok($ret, $right_ret);
