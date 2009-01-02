print "Testing: Instruction.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['i', 'perl', 'print "1\n";'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<?perl print "1\n";?>
END
ok($ret, $right_ret);
