# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 8;

print "Testing: Preserving from constructor (sgml version).\n";
print "- CHILD1 preserving is off.\n";
my $obj = Tags2::Output::Raw->new(
	'preserved' => [],
	'xml' => 0,
);
$obj->put(
	['b', 'CHILD1'],
	['d', 'DATA'],
	['e', 'CHILD1'],
);
my $ret = $obj->flush;
is($ret, "<CHILD1>DATA</CHILD1>");

$obj = Tags2::Output::Raw->new(
	'preserved' => [],
	'xml' => 0,
);
my $text = <<"END";
  text
     text
	text
END
$obj->put(
	['b', 'MAIN'],
	['b', 'CHILD1'],
	['d', $text],
	['e', 'CHILD1'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
my $right_ret = '<MAIN><CHILD1>'.$text.'</CHILD1></MAIN>';
is($ret, $right_ret);

print "- CHILD1 preserving is on.\n";
$obj = Tags2::Output::Raw->new(
	'preserved' => ['CHILD1'],
	'xml' => 0,
);
$obj->put(
	['b', 'CHILD1'],
	['d', 'DATA'],
	['e', 'CHILD1'],
);
$ret = $obj->flush;
is($ret, "<CHILD1>\nDATA</CHILD1>");

$obj = Tags2::Output::Raw->new(
	'preserved' => ['CHILD1'],
	'xml' => 0,
);
$obj->put(
	['b', 'MAIN'],
	['b', 'CHILD1'],
	['d', $text],
	['e', 'CHILD1'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = "<MAIN><CHILD1>\n$text</CHILD1></MAIN>";
is($ret, $right_ret);

print "Testing: Preserving from constructor (xml version).\n";
print "- child1 preserving is off.\n";
$obj = Tags2::Output::Raw->new(
	'preserved' => [],
	'xml' => 1,
);
$obj->put(
	['b', 'child1'],
	['d', 'data'],
	['e', 'child1'],
);
$ret = $obj->flush;
is($ret, "<child1>data</child1>");

$obj = Tags2::Output::Raw->new(
	'preserved' => [],
	'xml' => 1,
);
$text = <<"END";
  text
     text
	text
END
$obj->put(
	['b', 'main'],
	['b', 'child1'],
	['d', $text],
	['e', 'child1'],
	['e', 'main'],
);
$ret = $obj->flush;
$right_ret = '<main><child1>'.$text.'</child1></main>';
is($ret, $right_ret);

print "- child1 preserving is on.\n";
$obj = Tags2::Output::Raw->new(
	'preserved' => ['child1'],
	'xml' => 1,
);
$obj->put(
	['b', 'child1'],
	['d', 'data'],
	['e', 'child1'],
);
$ret = $obj->flush;
is($ret, "<child1>\ndata</child1>");

$obj = Tags2::Output::Raw->new(
	'preserved' => ['child1'],
	'xml' => 1,
);
$obj->put(
	['b', 'main'],
	['b', 'child1'],
	['d', $text],
	['e', 'child1'],
	['e', 'main'],
);
$ret = $obj->flush;
$right_ret = "<main><child1>\n$text</child1></main>";
is($ret, $right_ret);

# TODO Pridat vnorene testy.
# Bude jich hromada. Viz. ex18.pl az ex24.pl v Tags2::Output::Indent.