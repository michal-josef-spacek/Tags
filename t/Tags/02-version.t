# Pragmas.
use strict;
use warnings;

# Modules.
use Tags;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::VERSION, 0.07, 'Version.');
