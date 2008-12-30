print "Testing: Simple tag without parameters (sgml version).\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
(MAIN
)MAIN
END
ok($ret, $right_ret);

print "Testing: Simple tag with parameters (sgml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(MAIN
Aid id_value
)MAIN
END
ok($ret, $right_ret);

print "Testing: Simple tag after simple tag (sgml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN']
);
$ret = $obj->flush;
$right_ret = <<'END';
(MAIN
Aid id_value
)MAIN
(MAIN
Aid id_value2
)MAIN
END
ok($ret, $right_ret);

print "Testing: Simple tag without parameters (xml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'main'],
	['e', 'main'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(main
)main
END
ok($ret, $right_ret);

print "Testing: Simple tag with parameters (xml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(main
Aid id_value
)main
END
ok($ret, $right_ret);

print "Testing: Simple tag after simple tag (xml version).\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
	['b', 'main'],
	['a', 'id', 'id_value2'],
	['e', 'main'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(main
Aid id_value
)main
(main
Aid id_value2
)main
END
ok($ret, $right_ret);
