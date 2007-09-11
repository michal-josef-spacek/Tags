# $Id: 06_preserve_from_constructor.t,v 1.1 2007-09-11 12:04:17 skim Exp $

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
my $ret = go($obj, 1, ['b', 'MAIN'], ['b', 'CHILD1'], 
	['a', 'xml:space', 'default'], ['d', $text],
	['e', 'CHILD1'], ['e', 'MAIN']);
my $right_ret = '<MAIN><CHILD1 xml:space="default">'.$text.'</CHILD1></MAIN>';
ok($ret, $right_ret);

print "- CHILD1 preserving is on.\n" if $debug;
$obj = $class->new(
	'preserved' => ['CHILD1'],
);
$ret = go($obj, 1, ['b', 'MAIN'], ['b', 'CHILD1'], 
	['d', $text], ['e', 'CHILD1'], ['e', 'MAIN']);
$right_ret = "<MAIN><CHILD1>\n$text</CHILD1></MAIN>";
ok($ret, $right_ret);

# TODO Pridat vnorene testy.
# Bude jich hromada. Viz. ex18.pl az ex24.pl v Tags2::Output::Indent.
