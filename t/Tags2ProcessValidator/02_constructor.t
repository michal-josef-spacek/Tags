# $Id: 02_constructor.t,v 1.1 2008-07-30 22:43:44 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Tags2ProcessValidator";

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

print "Testing: new('dtd_file' => '$test_dir/DTD/fake.dtd') ".
	"right constructor - with fake readable dtd file.\n" if $debug;
$obj = $class->new('dtd_file' => "$test_dir/DTD/fake.dtd");
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);
