# $Id: 08_no_simple.t,v 1.1 2007-09-21 13:49:09 skim Exp $

print "Testing: Comment.\n" if $debug;
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
