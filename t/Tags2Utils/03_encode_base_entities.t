print "Testing: encode_base_entities() function.\n" if $debug;
my $string = 'a<a>a&a';
my $ret = eval $class.'::encode_base_entities($string)';
ok($ret, 'a&lt;a&gt;a&amp;a');

eval $class.'::encode_base_entities(\$string)';
ok($string, 'a&lt;a&gt;a&amp;a');

my @array = ('a<a', 'a>a', 'a&a');
eval $class.'::encode_base_entities(\@array)';
ok($array[0], 'a&lt;a');
ok($array[1], 'a&gt;a');
ok($array[2], 'a&amp;a');
