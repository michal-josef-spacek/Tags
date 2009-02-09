print "Testing: encode_base_entities() function.\n" if $debug;
my $string = 'a<a>a&a';
my $ret = eval $class.'::encode_base_entities($string)';
ok($ret, 'a&lt;a&gt;a&amp;a');

eval $class.'::encode_base_entities(\$string)';
ok($string, 'a&lt;a&gt;a&amp;a');
