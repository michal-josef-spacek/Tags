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

	# Ignore for this module.
	['r', 'ananas'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<tag>n.n.n.<![CDATA[n.n]]></tag>
END
ok($ret, $right_ret);
