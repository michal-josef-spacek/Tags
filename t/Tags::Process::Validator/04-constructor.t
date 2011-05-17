# Modules.
use English qw(-no_match_vars);
use File::Object;
use Tags::Process::Validator;
use Test::More 'tests' => 6;

# Directories.
my $dtd_dir = File::Object->new->up->dir('dtd');

my $obj;
eval {
	$obj = Tags::Process::Validator->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

eval {
	$obj = Tags::Process::Validator->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

eval {
	$obj = Tags::Process::Validator->new;
};
is($EVAL_ERROR, "Cannot read file with DTD defined by 'dtd_file' parameter.\n");

eval {
	$obj = Tags::Process::Validator->new(
		'dtd_file' => $dtd_dir->file('non_exist_file.dtd')->s,
	);
};
is($EVAL_ERROR, "Cannot read file '$dtd_dir/non_exist_file.dtd' with DTD.\n");

$obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('fake.dtd')->s,
);
ok(defined $obj);
ok($obj->isa('Tags::Process::Validator'));
