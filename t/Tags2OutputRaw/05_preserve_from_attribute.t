# $Id: 05_preserve_from_attribute.t,v 1.3 2008-07-17 10:22:46 skim Exp $

print "Testing: Preserving from attributes (sgml version).\n" if $debug;
print "- CHILD1 preserving is off.\n" if $debug;
my $obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 0,
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

print "Testing: Preserving from attributes (xml version).\n" if $debug;
print "- child1 preserving is off.\n" if $debug;
$obj = $class->new(
	'output_handler' => *STDOUT,
	'xml' => 1,
);
$ret = go($obj, 1, ['b', 'main'], ['b', 'child1'], 
	['a', 'xml:space', 'default'], ['d', $text],
	['e', 'child1'], ['e', 'main']);
$right_ret = '<main><child1 xml:space="default">'.$text.'</child1></main>';
ok($ret, $right_ret);

# TODO
#print "- CHILD1 preserving is on.\n" if $debug;
#$obj = $class->new(
#	'output_handler' => *STDOUT,
#);
#$ret = go($obj, 1, ['b', 'MAIN'], ['b', 'CHILD1'], 
#	['a', 'xml:space', 'preserve'], ['d', $text],
#	['e', 'CHILD1'], ['e', 'MAIN']);
#print "$ret\n";
#$right_ret = "<MAIN><CHILD1 xml:space=\"preserve\">\n$text</CHILD1></MAIN>";
#ok($ret, $right_ret);

# TODO Pridat vnorene testy.
# Bude jich hromada. Viz. ex18.pl az ex24.pl v Tags2::Output::Indent.
