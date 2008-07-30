# $Id: 02_constructor.t,v 1.1 2008-07-30 11:14:52 skim Exp $

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

print "Testing: new() right constructor.\n" if $debug;
eval {
	$obj = $class->new;
};
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);
