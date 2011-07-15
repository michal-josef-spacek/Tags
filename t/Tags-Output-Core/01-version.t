# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Core;
use Test::More 'tests' => 1;

# Test.
is($Tags::Output::Core::VERSION, 0.01, 'Version.');
