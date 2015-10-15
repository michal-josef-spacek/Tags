# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::Raw;
use Test::More 'tests' => 7;

# Test.
my $obj = Tags::Output::Raw->new(
	'xml' => 1,
);
$obj->put(
	['r', '<?xml version="1.1">'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1">
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$obj->reset;
$obj->put(
	['b', 'tag'],
	['r', 'raw'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<tag>raw</tag>
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$obj->reset;
$obj->put(
	['b', 'tag'],
	['b', 'other'],
	['r', 'raw'],
	['e', 'other'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<tag><other>raw</other></tag>
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$obj->reset;
$obj->put(
	['b', 'tag'],
	['b', 'other'],
	['b', 'xxx'],
	['r', 'raw'],
	['e', 'xxx'],
	['e', 'other'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<tag><other><xxx>raw</xxx></other></tag>
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$obj->reset;
$obj->put(
	['b', 'tag'],
	['r', '<![CDATA['],
	['d', 'bla'],
	['r', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag><![CDATA[bla]]></tag>';
is($ret, $right_ret);

# Test.
$obj->reset;
$obj->put(
	['b', 'tag'],
	['a', 'key', 'val'],
	['r', '<![CDATA['],
	['d', 'bla'],
	['r', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag key="val"><![CDATA[bla]]></tag>';
is($ret, $right_ret);

# Test.
$obj->reset;
$obj->put(
	['b', 'tag'],
	['a', 'key', 'val'],
	['r', '<![CDATA['],
	['b', 'other'],
	['d', 'bla'],
	['e', 'other'],
	['r', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = '<tag key="val"><![CDATA[<other>bla</other>]]></tag>';
is($ret, $right_ret);
