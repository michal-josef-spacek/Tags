# $Id: 12_auto_flush.t,v 1.2 2008-09-02 21:27:32 skim Exp $

# Modules.
use IO::Scalar;

print "Testing: 'auto_flush' parameter.\n" if $debug;
my $obj = $class->new(
	'auto_flush' => 1,
	'output_handler' => \*STDOUT,
);
my $ret;
tie *STDOUT, 'IO::Scalar', \$ret;
$obj->put(['b', 'tag']);
$obj->put(['e', 'tag']);
untie *STDOUT;
my $right_ret = '<tag />';
ok($ret, $right_ret);

$obj->reset;
undef $ret;
tie *STDOUT, 'IO::Scalar', \$ret;
$obj->put(['b', 'tag']);
$obj->put(['d', 'data']);
$obj->put(['e', 'tag']);
untie *STDOUT;
$right_ret = <<'END';
<tag>
  data
</tag>
END
chomp $right_ret;
ok($ret, $right_ret);
