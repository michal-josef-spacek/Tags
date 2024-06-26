use strict;
use warnings;

use Tags::Utils qw(encode_attr_entities);
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
my $string = 'a<a"a&a';
my $ret = encode_attr_entities($string);
is($ret, 'a&lt;a&quot;a&amp;a',
	'Encode attribute entities (&lt;, &quot; and &amp;).');

# Test.
encode_attr_entities(\$string);
is($string, 'a&lt;a&quot;a&amp;a',
	'Encode attribute entities defined by reference (&lt;, &quot; and &amp;).');

# Test.
my @array = ('a<a', 'a"a', 'a&a', 'a&lt;a', 'a&quot;a', 'a&amp;a');
encode_attr_entities(\@array);
is_deeply(
	\@array,
	[
		'a&lt;a',
		'a&quot;a',
		'a&amp;a',
		'a&lt;a',
		'a&quot;a',
		'a&amp;a',
	],
	'Encode attribute entities defined by array (&lt;, &quot; and &amp;).',
);
