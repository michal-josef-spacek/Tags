# Modules.
use Test::Pod::Coverage 'tests' => 1;

print "Testing: Pod coverage.\n";
pod_coverage_ok('Tags::Utils::Preserve', 'Tags::Utils::Preserve is covered.');
