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

print "Testing: new('auto_flush' => 1) bad constructor.\n" if $debug;
eval {
	$obj = $class->new('auto_flush' => 1);
};
ok($@, 'Auto-flush can\'t use without output handler.'."\n");

print "Testing: new('output_handler' = '') bad constructor.\n" if $debug;
eval {
	$obj = $class->new('output_handler' => '');
};
ok($@, 'Output handler is bad file handler.'."\n");

print "Testing: new() right constructor.\n" if $debug;
eval {
	$obj = $class->new;
};
ok(defined $obj, 1);
ok($obj->isa($class), 1);
