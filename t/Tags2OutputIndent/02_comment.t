# $Id: 02_comment.t,v 1.1 2007-09-20 14:44:39 skim Exp $

print "Testing: Comment.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
my $right_ret = "<!--comment-->\n<!-- comment -->";
ok($ret, $right_ret);
