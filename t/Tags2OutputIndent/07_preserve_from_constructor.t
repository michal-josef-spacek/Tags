# $Id: 07_preserve_from_constructor.t,v 1.1 2007-09-20 21:40:21 skim Exp $

print "Testing: Preserving from constructor.\n" if $debug;
print "- CHILD1 preserving is off.\n" if $debug;
my $obj = $class->new(
	'preserved' => [],
);
my $text = <<"END";
  text
     text
	text
END
$obj->put(
	['b', 'MAIN'],
	['b', 'CHILD1'],
	['a', 'xml:space', 'default'],
	['d', $text],
	['e', 'CHILD1'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = "<MAIN>\n  <CHILD1 xml:space=\"default\">\n    $text\n  </CHILD1>\n</MAIN>";
ok($ret, $right_ret);

print "- CHILD1 preserving is on.\n" if $debug;
$obj = $class->new(
	'preserved' => ['CHILD1'],
);
$obj->put(
	['b', 'MAIN'],
	['b', 'CHILD1'],
	['d', $text],
	['e', 'CHILD1'],
	['e', 'MAIN']
);
$ret = $obj->flush;
$right_ret = "<MAIN>\n  <CHILD1>\n$text</CHILD1>\n</MAIN>";
ok($ret, $right_ret);

# TODO Pridat vnorene testy.
# Bude jich hromada. Viz. ex18.pl az ex24.pl v Tags2::Output::Indent.
