# Modules.
use Tags2::Utils::Preserve;
use Test::More 'tests' => 4;

print "Testing: new('') bad constructor.\n";
my $obj;
eval {
	$obj = Tags2::Utils::Preserve->new('');
};
is($@, "Bad parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n";
eval {
	$obj = Tags2::Utils::Preserve->new('something' => 'value');
};
is($@, "Bad parameter 'something'.\n");

print "Testing: new() right constructor.\n";
eval {
	$obj = Tags2::Utils::Preserve->new;
};
ok(defined $obj);
ok($obj->isa('Tags2::Utils::Preserve'));
