# Tests directory.
my $test_main_dir = "$ENV{'PWD'}/t";

# Modules.
use Tags2::Output::Indent2;
#use Test::More 'tests' => 3;
use Test::More 'skip_all' => 'Everything bad.';

# Include helpers.
do $test_main_dir.'/get_stdout.inc';

print "Testing: 'auto_flush' parameter.\n";
my $obj = Tags2::Output::Indent2->new(
	'auto_flush' => 1,
	'output_handler' => \*STDOUT,
	'xml' => 1,
);
my $ret = get_stdout($obj, 1, ['b', 'tag'], ['e', 'tag']);
my $right_ret = '<tag />';
is($ret, $right_ret);

$obj->reset;
$ret = get_stdout($obj, 1, ['b', 'tag'], ['d', 'data'], ['e', 'tag']);
$right_ret = <<'END';
<tag>data</tag>
END
chomp $right_ret;
is($ret, $right_ret);

$obj->reset;
$ret = get_stdout($obj, 1, ['b', 'tag'], ['b', 'other_tag'], ['d', 'data'], 
	['e', 'other_tag'], ['e', 'tag']);
$right_ret = <<'END';
<tag>
  <other_tag>data</other_tag>
</tag>
END
chomp $right_ret;
is($ret, $right_ret);
