# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Tags::Utils::Preserve;
use Test::More 'tests' => 3;

# Test.
eval {
	Tags::Utils::Preserve->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

# Test.
eval {
	Tags::Utils::Preserve->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

# Test.
my $obj = Tags::Utils::Preserve->new;
isa_ok($obj, 'Tags::Utils::Preserve');
