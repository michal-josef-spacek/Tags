# Modules.
use Test::Pod::Coverage 'tests' => 1;

# Test.
pod_coverage_ok('Tags::Process::Validator',
	'Tags::Process::Validator is covered.');
