# $Id: 07_comment.t,v 1.1 2007-09-20 14:44:40 skim Exp $

print "Testing: Comment.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
my $right_ret = '<!--comment--><!-- comment -->';
ok($ret, $right_ret);
