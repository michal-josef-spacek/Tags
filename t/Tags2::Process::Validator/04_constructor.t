# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Tags2::Process::Validator";

# Modules.
use Tags2::Process::Validator;
use Test::More 'tests' => 6;

print "Testing: new('') bad constructor.\n";
my $obj;
eval {
	$obj = Tags2::Process::Validator->new('');
};
is($@, "Bad parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n";
eval {
	$obj = Tags2::Process::Validator->new('something' => 'value');
};
is($@, "Bad parameter 'something'.\n");

print "Testing: new() bad constructor.\n";
eval {
	$obj = Tags2::Process::Validator->new;
};
is($@, "Cannot read file with DTD defined by 'dtd_file' paremeter.\n");

print "Testing: new('dtd_file' => '$test_dir/DTD/non_exist_file.dtd')\n";
eval {
	$obj = Tags2::Process::Validator->new(
		'dtd_file' => "$test_dir/DTD/non_exist_file.dtd"
	);
};
is($@, "Cannot read file '$test_dir/DTD/non_exist_file.dtd' with DTD.\n");

print "Testing: new('dtd_file' => '$test_dir/DTD/fake.dtd') ".
	"right constructor - with fake readable dtd file.\n";
$obj = Tags2::Process::Validator->new('dtd_file' => "$test_dir/DTD/fake.dtd");
ok(defined $obj);
ok($obj->isa('Tags2::Process::Validator'));