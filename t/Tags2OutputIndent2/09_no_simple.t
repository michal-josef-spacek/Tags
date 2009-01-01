print "Testing: No simple.\n" if $debug;
my $obj = $class->new(
	'no_simple' => ['tag'],
);
$obj->put(
	['b', 'tag'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<tag></tag>
END
chomp $right_ret;
ok($ret, $right_ret);
