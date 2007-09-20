# $Id: 03_constructor.t,v 1.1 2007-09-20 21:22:12 skim Exp $

print "Testing: new('') bad constructor.\n" if $debug;
my $obj;
eval {
	$obj = $class->new('');
};
ok($@, "Bad parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n" if $debug;
eval {
	$obj = $class->new('something' => 'value');
};
ok($@, "Bad parameter 'something'.\n");

print "Testing: new('attr_delimeter' => '-') bad constructor.\n" if $debug;
eval {
	$obj = $class->new('attr_delimeter' => '-');
};
ok($@, "Bad attribute delimeter '-'.\n");

print "Testing: new() right constructor.\n" if $debug;
eval {
	$obj = $class->new;
};
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);
