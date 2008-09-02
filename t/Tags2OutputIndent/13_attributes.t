# $Id: 13_attributes.t,v 1.1 2008-09-02 22:26:57 skim Exp $

print "Testing: Attributes.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['b', 'foo'],
	['a', 'one', '...........................'],
	['a', 'two', '...........................'],
	['a', 'three', '.........................'],
	['e', 'foo'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<foo one="..........................." two="..........................." three=
  "........................." />
END
chomp $right_ret;
ok($ret, $right_ret);
