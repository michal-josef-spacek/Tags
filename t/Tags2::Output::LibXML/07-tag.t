# Modules.
use Tags2::Output::LibXML;
use Test::More 'tests' => 5;

print "Testing: Normal tag without parameters.\n";
my $obj = Tags2::Output::LibXML->new;
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
is($ret, $right_ret);

print "Testing: Normal tag with parameters.\n";
$obj = Tags2::Output::LibXML->new;
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
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'MAIN'], 
	['a', 'id', 0], 
	['d', 'data'], 
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN id="0">data</MAIN>
END
is($ret, $right_ret);

print "Testing: Normal tag with long data.\n";
my $long_data = 'a' x 1000;
$obj = Tags2::Output::LibXML->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
<?xml version="1.1" encoding="UTF-8"?>
<MAIN>$long_data</MAIN>
END
is($ret, $right_ret);

$long_data = 'aaaa ' x 1000;
$obj = Tags2::Output::LibXML->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
<?xml version="1.1" encoding="UTF-8"?>
<MAIN>$long_data</MAIN>
END
is($ret, $right_ret);
