# Modules.
use English qw(-no_match_vars);
use Tags2::Output::Core;
use Test::More 'tests' => 3;

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
isa_ok($obj, 'Tags2::Output::Core');
