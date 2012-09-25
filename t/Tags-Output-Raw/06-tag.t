# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 11;

# Test.
my $obj = Tags::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
is($ret, '<MAIN>data</MAIN>');

# Test.
$obj->reset;
$obj->put(
	['b', 'TAG'], 
	['b', 'TAG2'], 
	['e', 'TAG'],
);
$ret = $obj->flush;
is($ret, '<TAG><TAG2></TAG>');

# Test.
$obj = Tags::Output::Raw->new(
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

# Test.
$obj = Tags::Output::Raw->new(
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

# Test.
$obj = Tags::Output::Raw->new(
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

# Test.
$obj = Tags::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'], 
	['d', 'data'], 
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main>data</main>');

# Test.
$obj = Tags::Output::Raw->new(
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

# Test.
$obj->reset;
$obj->put(
	['b', 'main'], 
	['a', 'id', 0], 
	['d', 'data'], 
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="0">data</main>');

# Test.
$obj = Tags::Output::Raw->new(
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

# Test.
my $long_data = 'a' x 1000;
$obj = Tags::Output::Raw->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
my $right_ret = <<"END";
<MAIN>$long_data</MAIN>
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$long_data = 'aaaa ' x 1000;
$obj = Tags::Output::Raw->new;
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
