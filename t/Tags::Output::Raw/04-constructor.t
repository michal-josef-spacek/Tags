# Modules.
use English qw(-no_match_vars);
use Tags::Output::Raw;
use Test::More 'tests' => 7;

# Test.
eval {
	Tags::Output::Raw->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

# Test.
eval {
	Tags::Output::Raw->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

# Test.
eval {
	Tags::Output::Raw->new('attr_delimeter' => '-');
};
is($EVAL_ERROR, "Bad attribute delimeter '-'.\n");

# Test.
eval {
	Tags::Output::Raw->new('auto_flush' => 1);
};
is($EVAL_ERROR, 'Auto-flush can\'t use without output handler.'."\n");

# Test.
eval {
	Tags::Output::Raw->new('output_handler' => '');
};
is($EVAL_ERROR, 'Output handler is bad file handler.'."\n");

# Test.
my $obj = Tags::Output::Raw->new;
ok(defined $obj);
ok($obj->isa('Tags::Output::Raw'));
