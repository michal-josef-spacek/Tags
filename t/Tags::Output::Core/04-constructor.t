# Modules.
use English qw(-no_match_vars);
use Tags2::Output::Core;
use Test::More 'tests' => 4;

my $obj;
eval {
	$obj = Tags2::Output::Core->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

eval {
	$obj = Tags2::Output::Core->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

$obj = Tags2::Output::Core->new;
ok(defined $obj);
ok($obj->isa('Tags2::Output::Core'));
