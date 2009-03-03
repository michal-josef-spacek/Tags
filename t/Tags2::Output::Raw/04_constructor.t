# Modules.
use Tags2::Output::Raw;
use Test::More 'tests' => 7;

print "Testing: new('') bad constructor.\n";
my $obj;
eval {
	$obj = Tags2::Output::Raw->new('');
};
is($@, "Bad parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n";
eval {
	$obj = Tags2::Output::Raw->new('something' => 'value');
};
is($@, "Bad parameter 'something'.\n");

print "Testing: new('attr_delimeter' => '-') bad constructor.\n";
eval {
	$obj = Tags2::Output::Raw->new('attr_delimeter' => '-');
};
is($@, "Bad attribute delimeter '-'.\n");

print "Testing: new('auto_flush' => 1) bad constructor.\n";
eval {
	$obj = Tags2::Output::Raw->new('auto_flush' => 1);
};
is($@, 'Auto-flush can\'t use without output handler.'."\n");

print "Testing: new('output_handler' = '') bad constructor.\n";
eval {
	$obj = Tags2::Output::Raw->new('output_handler' => '');
};
is($@, 'Output handler is bad file handler.'."\n");

print "Testing: new() right constructor.\n";
$obj = Tags2::Output::Raw->new;
ok(defined $obj);
ok($obj->isa('Tags2::Output::Raw'));
