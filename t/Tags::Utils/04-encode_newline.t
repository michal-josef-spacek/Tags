# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Utils qw(encode_newline);
use Test::More 'tests' => 1;

# Test.
my $string = "text\ntext";
my $ret = encode_newline($string);
is($ret, 'text\\ntext');
