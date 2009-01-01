print "Testing: Instruction.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['i', 'perl', 'print "1\n";'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?perl print "1\n";?>
END
chomp $right_ret;
ok($ret, $right_ret);
