print "Testing: Instruction.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['i', 'perl'],
	['i', 'perl', 'print "1";'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
?perl
?perl print "1";
END
chomp $right_ret;
ok($ret, $right_ret);
