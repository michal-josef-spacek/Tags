print "Testing: Tags combination.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['c', ' COMMENT '],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['d', 'DATA'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<MAIN>
  <!-- COMMENT -->
</MAIN>
<MAIN>
  DATA
</MAIN>
END
chomp $right_ret;
ok($ret, $right_ret);
