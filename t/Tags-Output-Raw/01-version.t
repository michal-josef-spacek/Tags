# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 1;

# Test.
is($Tags::Output::Raw::VERSION, 0.01, 'Version.');
