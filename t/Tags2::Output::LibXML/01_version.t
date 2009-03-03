# Modules.
use Tags2::Output::LibXML;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags2::Output::LibXML::VERSION, '0.02');
