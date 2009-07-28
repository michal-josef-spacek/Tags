# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 11;

print "Testing: Normal tag without parameters (sgml version).\n";
my $obj = Tags2::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
is($ret, '<MAIN>data</MAIN>');

$obj->reset;
$obj->put(
	['b', 'TAG'], 
	['b', 'TAG2'], 
	['e', 'TAG'],
);
$ret = $obj->flush;
is($ret, '<TAG><TAG2></TAG>');

print "Testing: Normal tag with parameters (sgml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'], 
	['a', 'id', 'id_value'], 
	['d', 'data'], 
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id="id_value">data</MAIN>');

print "Testing: Normal tag with simple parameters (sgml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['a', 'disabled'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN disabled>data</MAIN>');

print "Testing: Normal tag after normal tag (sgml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 0,
);
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
is($ret, '<MAIN id="id_value">data</MAIN><MAIN id="id_value2">data</MAIN>');

print "Testing: Normal tag without parameters (xml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'], 
	['d', 'data'], 
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main>data</main>');

print "Testing: Normal tag with parameters (xml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'], 
	['a', 'id', 'id_value'], 
	['d', 'data'], 
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="id_value">data</main>');

$obj->reset;
$obj->put(
	['b', 'main'], 
	['a', 'id', 0], 
	['d', 'data'], 
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="0">data</main>');

print "Testing: Normal tag after normal tag (xml version).\n";
$obj = Tags2::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'], 
	['a', 'id', 'id_value'], 
	['d', 'data'], 
	['e', 'main'], 
	['b', 'main'], 
	['a', 'id', 'id_value2'], 
	['d', 'data'], 
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="id_value">data</main><main id="id_value2">data</main>');

print "Testing: Normal tag with long data.\n";
my $long_data = 'a' x 1000;
$obj = Tags2::Output::Raw->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
<MAIN>$long_data</MAIN>
END
chomp $right_ret;
is($ret, $right_ret);

$long_data = 'aaaa ' x 1000;
$obj = Tags2::Output::Raw->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
<MAIN>$long_data</MAIN>
END
chomp $right_ret;
is($ret, $right_ret);
