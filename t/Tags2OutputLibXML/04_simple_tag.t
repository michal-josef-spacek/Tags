print "Testing: Simple tag without parameters (sgml version).\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN/>
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
<?xml version="1.1" encoding="UTF-8"?>
<MAIN id="id_value"/>
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
<?xml version="1.1" encoding="UTF-8"?>
<main/>
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
<?xml version="1.1" encoding="UTF-8"?>
<main id="id_value"/>
END
ok($ret, $right_ret);
