# Modules.
use Tags2::Output::Core;
use Test::More 'tests' => 1;

my $obj = Tags2::Output::Core->new;
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
chomp $right_ret;
is($ret, $right_ret);
