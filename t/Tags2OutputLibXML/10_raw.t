print "Testing: Raw.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'tag'],
	['r', 'Raw'],
	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<tag/>
END
ok($ret, $right_ret);
