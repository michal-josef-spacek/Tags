# Modules.
use Test::Pod::Coverage 'tests' => 1;

print "Testing: Pod coverage.\n";
pod_coverage_ok('Tags2::Output::ESIS', 'Tags2::Output::ESIS is covered.');
