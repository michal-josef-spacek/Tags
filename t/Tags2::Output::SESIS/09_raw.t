# Modules.
use Tags2::Output::SESIS;
use Test::More 'tests' => 7;

print "Testing: Raw.\n";
my $obj = Tags2::Output::SESIS->new;
$obj->put(
	['r', '<?xml version="1.1">'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
R<?xml version="1.1">
END
chomp $right_ret;
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['r', 'raw'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(tag
Rraw
)tag
END
chomp $right_ret;
is($ret, $right_ret);

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
(tag
(other
Rraw
)other
)tag
END
chomp $right_ret;
is($ret, $right_ret);

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
(tag
(other
(xxx
Rraw
)xxx
)other
)tag
END
chomp $right_ret;
is($ret, $right_ret);

$obj->reset;
$obj->put(
	['b', 'tag'],
	['r', '<![CDATA['],
	['d', 'bla'],
	['r', ']]>'],
	['e', 'tag'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(tag
R<![CDATA[
-bla
R]]>
)tag
END
chomp $right_ret;
is($ret, $right_ret);

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
$right_ret = <<'END';
(tag
Akey val
R<![CDATA[
-bla
R]]>
)tag
END
chomp $right_ret;
is($ret, $right_ret);

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
$right_ret = <<'END';
(tag
Akey val
R<![CDATA[
(other
-bla
)other
R]]>
)tag
END
chomp $right_ret;
is($ret, $right_ret);
