# Modules.
use Tags2::Output::SESIS;
use English qw(-no_match_vars);
use Test::More 'tests' => 5;

print "Testing: flush() method.\n";
my $obj = Tags2::Output::SESIS->new;
$obj->put(
	['b', 'tag'],
	['d', 'data'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
(tag
-data
)tag
END
chomp $right_ret;
is($ret, $right_ret);

$obj->put(
	['b', 'tag'],
	['d', 'data'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(tag
-data
)tag
(tag
-data
)tag
END
chomp $right_ret;
is($ret, $right_ret);

$obj->put(
	['b', 'tag'],
	['d', 'data'],
	['e', 'tag'],
);
$ret = $obj->flush(1);
$right_ret = <<'END';
(tag
-data
)tag
(tag
-data
)tag
(tag
-data
)tag
END
chomp $right_ret;
is($ret, $right_ret);

$obj->put(
	['b', 'tag'],
	['d', 'data'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(tag
-data
)tag
END
chomp $right_ret;
is($ret, $right_ret);

SKIP: {
	eval {
		require File::Temp;
	};
	if ($EVAL_ERROR) {
		skip 'File::Temp not installed', 1;
	};
	my $temp_fh = File::Temp::tempfile();
	$obj = Tags2::Output::SESIS->new(
		'output_handler' => $temp_fh,
	);
	$obj->put(
		['b', 'tag'],
		['d', 'data'],
		['e', 'tag'],
	);
	$temp_fh->close;
	eval {
		$ret = $obj->flush;
	};
	is($EVAL_ERROR, "Cannot write to output handler.\n");
}
