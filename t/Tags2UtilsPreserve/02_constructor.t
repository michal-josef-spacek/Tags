print "Testing: new('') bad constructor.\n" if $debug;
my $obj;
eval {
	$obj = $class->new('');
};
is($@, "Bad parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n" if $debug;
eval {
	$obj = $class->new('something' => 'value');
};
is($@, "Bad parameter 'something'.\n");

print "Testing: new() right constructor.\n" if $debug;
eval {
	$obj = $class->new;
};
is(defined $obj, 1);
is($obj->isa($class), 1);
