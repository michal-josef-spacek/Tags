print "Testing: encode_newline() function.\n" if $debug;
my $string = "text\ntext";
my $ret = eval $class.'::encode_newline($string)';
ok($ret, 'text\\ntext');
