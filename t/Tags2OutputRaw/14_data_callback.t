print "Testing: 'data_callback' parameter.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
	['d', 'a<a', 'a>a', 'a&a'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<tag>a&lt;aa&gt;aa&amp;a</tag>
END
chomp $right_ret;
ok($ret, $right_ret);

my $sub = sub {
	my $data_arr_ref = shift;
	foreach my $data (@{$data_arr_ref}) {
		$data =~ s/a/\./g;
	}
	return;
};
$obj = $class->new(
	'cdata_callback' => $sub,
	'data_callback' => $sub,
	'raw_callback' => $sub,
);
$obj->put(
	['b', 'tag'],
	['d', 'nan', 'ana'],
	['cd', 'nan'],
	['e', 'tag'],
	['r', 'ananas'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<tag>n.n.n.<![CDATA[n.n]]></tag>.n.n.s
END
chomp $right_ret;
ok($ret, $right_ret);
