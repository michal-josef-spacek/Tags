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

$obj->reset;
$obj->put(
	['b', 'tag'],
	['i', 'perl', 'print "1\n";'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<tag><?perl print "1\n";?></tag>
END
chomp $right_ret;
ok($ret, $right_ret);
