# $Id: 03_simple_tag.t,v 1.3 2007-09-21 14:09:52 skim Exp $

print "Testing: Simple tag without parameters.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
ok($ret, '<MAIN />');

print "Testing: Simple tag with parameters.\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
ok($ret, '<MAIN id="id_value" />');

print "Testing: Simple tag after simple tag.\n" if $debug;
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
ok($ret, '<MAIN id="id_value" /><MAIN id="id_value2" />');
