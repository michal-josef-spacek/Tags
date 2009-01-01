print "Testing: Normal tag without parameters.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<MAIN>
  data
</MAIN>
END
chomp $right_ret;
ok($ret, $right_ret);

print "Testing: Normal tag with parameters.\n" if $debug;
$obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<MAIN id="id_value">
  data
</MAIN>
END
chomp $right_ret;
ok($ret, $right_ret);

print "Testing: Normal tag after normal tag.\n" if $debug;
$obj = $class->new;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['d', 'data'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<MAIN id="id_value">
  data
</MAIN>
<MAIN id="id_value2">
  data
</MAIN>
END
chomp $right_ret;
ok($ret, $right_ret);
