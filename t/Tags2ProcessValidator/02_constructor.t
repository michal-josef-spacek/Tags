# $Id: 02_constructor.t,v 1.2 2008-08-16 19:32:06 skim Exp $

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

print "Testing: new() bad constructor.\n" if $debug;
eval {
	$obj = $class->new;
};
ok($@, "Cannot read file with DTD defined by 'dtd_file' paremeter.\n");

print "Testing: new('dtd_file' => '$test_dir/DTD/non_exist_file.dtd')\n" 
	if $debug;
eval {
	$obj = $class->new('dtd_file' => "$test_dir/DTD/non_exist_file.dtd");
};
ok($@, "Cannot read file '$test_dir/DTD/non_exist_file.dtd' with DTD.\n");

print "Testing: new('dtd_file' => '$test_dir/DTD/fake.dtd') ".
	"right constructor - with fake readable dtd file.\n" if $debug;
$obj = $class->new('dtd_file' => "$test_dir/DTD/fake.dtd");
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);
