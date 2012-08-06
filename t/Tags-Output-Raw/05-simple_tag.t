# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 10;

# Test.
my $obj = Tags::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
is($ret, '<MAIN></MAIN>');

# Test.
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id="id_value"></MAIN>');
$obj = Tags::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id=\'id_value\'></MAIN>');

# Test.
$obj = Tags::Output::Raw->new(
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id="id_value"></MAIN><MAIN id="id_value2"></MAIN>');
$obj = Tags::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
is($ret, '<MAIN id=\'id_value\'></MAIN><MAIN id=\'id_value2\'></MAIN>');

# Test.
$obj = Tags::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main />');

# Test.
$obj->reset;
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="id_value" />');
$obj = Tags::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id=\'id_value\' />');

# Test.
$obj = Tags::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
	['b', 'main'],
	['a', 'id', 'id_value2'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id="id_value" /><main id="id_value2" />');
$obj = Tags::Output::Raw->new(
	'attr_delimeter' => q{'},
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
	['b', 'main'],
	['a', 'id', 'id_value2'],
	['e', 'main'],
);
$ret = $obj->flush;
is($ret, '<main id=\'id_value\' /><main id=\'id_value2\' />');
