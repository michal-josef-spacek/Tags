# $Id: 05_tag.t,v 1.1 2007-09-20 21:28:49 skim Exp $

print "Testing: Normal tag without parameters.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
ok($ret, "<MAIN>\n  data\n</MAIN>");

print "Testing: Normal tag with parameters.\n" if $debug;
$obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
ok($ret, "<MAIN id=\"id_value\">\n  data\n</MAIN>");

print "Testing: Normal tag after normal tag.\n" if $debug;
$obj = $class->new;
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
ok($ret, "<MAIN id=\"id_value\">\n  data\n</MAIN>\n<MAIN id=\"id_value2\">\n  data\n</MAIN>");
