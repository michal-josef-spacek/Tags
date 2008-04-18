# $Id: 08_no_simple.t,v 1.2 2008-04-18 17:03:47 skim Exp $

print "Testing: No simple.\n" if $debug;
my $obj = $class->new(
	'no_simple' => ['tag'],
);
$obj->put(
	['b', 'tag'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = '<tag></tag>';
ok($ret, $right_ret);

