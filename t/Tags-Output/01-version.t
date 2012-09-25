# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output;
use Test::More 'tests' => 1;

# Test.
is($Tags::Output::VERSION, 0.01, 'Version.');
