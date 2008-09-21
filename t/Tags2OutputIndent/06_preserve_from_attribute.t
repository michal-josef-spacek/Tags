print "Testing: Preserving from attributes.\n" if $debug;
print "- CHILD1 preserving is off.\n" if $debug;
my $obj = $class->new;
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
