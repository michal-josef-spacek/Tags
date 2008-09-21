print "Testing: Preserving from attributes (sgml version).\n" if $debug;
print "- CHILD1 preserving is off.\n" if $debug;
my $obj = $class->new(
	'xml' => 0,
);
my $text = <<"END";
  text
     text
	text
END
$obj->put(['b', 'MAIN'], ['b', 'CHILD1'], 
	['a', 'xml:space', 'default'], ['d', $text],
	['e', 'CHILD1'], ['e', 'MAIN']);
my $ret = $obj->flush;
my $right_ret = '<MAIN><CHILD1 xml:space="default">'.$text.'</CHILD1></MAIN>';
ok($ret, $right_ret);

print "Testing: Preserving from attributes (xml version).\n" if $debug;
print "- child1 preserving is off.\n" if $debug;
$obj = $class->new(
	'xml' => 1,
);
$obj->put(['b', 'main'], ['b', 'child1'], 
	['a', 'xml:space', 'default'], ['d', $text],
	['e', 'child1'], ['e', 'main']);
$ret = $obj->flush;
$right_ret = '<main><child1 xml:space="default">'.$text.'</child1></main>';
ok($ret, $right_ret);

# TODO
#print "- CHILD1 preserving is on.\n" if $debug;
#$obj = $class->new;
#$obj->put(['b', 'MAIN'], ['b', 'CHILD1'], 
#	['a', 'xml:space', 'preserve'], ['d', $text],
#	['e', 'CHILD1'], ['e', 'MAIN']);
#$ret = $obj->flush;
#print "$ret\n";
#$right_ret = "<MAIN><CHILD1 xml:space=\"preserve\">\n$text</CHILD1></MAIN>";
#ok($ret, $right_ret);

# TODO Pridat vnorene testy.
# Bude jich hromada. Viz. ex18.pl az ex24.pl v Tags2::Output::Indent.
