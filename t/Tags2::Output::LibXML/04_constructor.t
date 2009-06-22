# Modules.
use English qw(-no_match_vars);
use Tags2::Output::LibXML;
use Test::More 'tests' => 4;

print "Testing: new('') bad constructor.\n";
my $obj;
eval {
	$obj = Tags2::Output::LibXML->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n";
eval {
	$obj = Tags2::Output::LibXML->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

print "Testing: new() right constructor.\n";
$obj = Tags2::Output::LibXML->new;
ok(defined $obj);
ok($obj->isa('Tags2::Output::LibXML'));
