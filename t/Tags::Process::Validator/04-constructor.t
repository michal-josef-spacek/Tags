# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use File::Object;
use Tags::Process::Validator;
use Test::More 'tests' => 5;

# Directories.
my $dtd_dir = File::Object->new->up->dir('dtd');

# Test.
eval {
	Tags::Process::Validator->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

# Test.
eval {
	Tags::Process::Validator->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

# Test.
eval {
	Tags::Process::Validator->new;
};
is($EVAL_ERROR, "Cannot read file with DTD defined by 'dtd_file' parameter.\n");

# Test.
my $dtd_file = $dtd_dir->file('non_exist_file.dtd')->s;
eval {
	Tags::Process::Validator->new(
		'dtd_file' => $dtd_file,
	);
};
is($EVAL_ERROR, "Cannot read file '$dtd_file' with DTD.\n");

# Test.
my $obj = Tags::Process::Validator->new(
	'dtd_file' => $dtd_dir->file('fake.dtd')->s,
);
isa_ok($obj, 'Tags::Process::Validator');
