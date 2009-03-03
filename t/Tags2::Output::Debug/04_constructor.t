# Modules.
use Tags2::Output::Debug;
use Test::More 'tests' => 4;

print "Testing: new('') bad constructor.\n";
my $obj;
eval {
	$obj = Tags2::Output::Debug->new('');
};
is($@, "Bad parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n";
eval {
	$obj = Tags2::Output::Debug->new('something' => 'value');
};
is($@, "Bad parameter 'something'.\n");

print "Testing: new() right constructor.\n";
$obj = Tags2::Output::Debug->new;
ok(defined $obj);
ok($obj->isa('Tags2::Output::Debug'));
