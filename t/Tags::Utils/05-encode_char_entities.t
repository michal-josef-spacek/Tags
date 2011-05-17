# Modules.
use Tags::Utils qw(encode_char_entities);
use Test::More 'tests' => 3;

print "Testing: encode_char_entities() function.\n";
my $string = 'a<a&a'."\240a";
my $ret = encode_char_entities($string);
is($ret, 'a&lt;a&amp;a&nbsp;a');

encode_char_entities(\$string);
is($string, 'a&lt;a&amp;a&nbsp;a');

my @array = ('a<a', "a\240a", 'a&a', 'a&lt;a', 'a&nbsp;a', 'a&amp;a');
encode_char_entities(\@array);
is_deeply(
	\@array,
	[
		'a&lt;a',
		'a&nbsp;a',
		'a&amp;a',
		'a&lt;a',
		'a&nbsp;a',
		'a&amp;a',
	],
);
