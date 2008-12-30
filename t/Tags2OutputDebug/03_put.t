print "Testing: put() method.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['a', 'key', 'val'],
	['b', 'tag'],
	['c', 'comment'],
	['cd', 'cdata section'],
	['d', 'data section'],
	['e', 'tag'],
	['i', 'target', 'code'],
	['r', 'raw data'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
Attribute
Begin of tag
Comment
CData
Data
End of tag
Instruction
Raw data
END
ok($ret, $right_ret);
