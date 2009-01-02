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
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN><CHILD1 xml:space="default">  text
     text
	text
</CHILD1></MAIN>
END
ok($ret, $right_ret);

print "- CHILD1 preserving is on.\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['b', 'CHILD1'],
	['a', 'xml:space', 'preserve'],
	['d', $text],
	['e', 'CHILD1'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN><CHILD1 xml:space="preserve">  text
     text
	text
</CHILD1></MAIN>
END
ok($ret, $right_ret);

# TODO Pridat vnorene testy.
# Bude jich hromada. Viz. ex18.pl az ex24.pl v Tags2::Output::Indent.
