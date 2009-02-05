print "Testing: 'data_callback' parameter.\n" if $debug;
my $obj = $class->new(
	'data_callback' => sub {
		my $data_arr_ref = shift;
		foreach my $data (@{$data_arr_ref}) {
			$data =~ s/a/\./g;
		}
	},
);
$obj->put(
	['b', 'tag'],
	['d', 'nan', 'ana'],
	['cd', 'nan'],
	['e', 'tag'],
	['r', 'ananas'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<tag>
  n.n.n.
  <![CDATA[n.n]]>
</tag>.n.n.s
END
chomp $right_ret;
ok($ret, $right_ret);
