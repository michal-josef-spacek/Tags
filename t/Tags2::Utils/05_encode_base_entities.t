# Modules.
use Tags2::Utils qw(encode_base_entities);
use Test::More 'tests' => 5;

print "Testing: encode_base_entities() function.\n";
my $string = 'a<a>a&a';
my $ret = encode_base_entities($string);
is($ret, 'a&lt;a&gt;a&amp;a');

encode_base_entities(\$string);
is($string, 'a&lt;a&gt;a&amp;a');

my @array = ('a<a', 'a>a', 'a&a');
encode_base_entities(\@array);
is($array[0], 'a&lt;a');
is($array[1], 'a&gt;a');
is($array[2], 'a&amp;a');
