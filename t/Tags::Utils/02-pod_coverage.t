# Modules.
use Test::Pod::Coverage 'tests' => 1;

print "Testing: Pod coverage.\n";
pod_coverage_ok('Tags2::Utils', 'Tags2::Utils is covered.');
