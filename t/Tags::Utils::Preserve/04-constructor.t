# Modules.
use English qw(-no_match_vars);
use Tags::Utils::Preserve;
use Test::More 'tests' => 4;

eval {
	Tags::Utils::Preserve->new('');
};
is($EVAL_ERROR, "Bad parameter ''.\n");

eval {
	Tags::Utils::Preserve->new('something' => 'value');
};
is($EVAL_ERROR, "Bad parameter 'something'.\n");

my $obj = Tags::Utils::Preserve->new;
ok(defined $obj);
ok($obj->isa('Tags::Utils::Preserve'));
