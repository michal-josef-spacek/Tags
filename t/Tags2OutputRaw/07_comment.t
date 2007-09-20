# $Id: 07_comment.t,v 1.2 2007-09-20 14:54:07 skim Exp $

print "Testing: Comment.\n" if $debug;
my $obj = $class->new;
$obj->put(
	['c', 'comment'],
	['c', ' comment '],
);
my $ret = $obj->flush;
my $right_ret = '<!--comment--><!-- comment -->';
ok($ret, $right_ret);

$obj->reset;
$obj->put(
	['c', 'comment-'],
);
$ret = $obj->flush;
$right_ret = '<!--comment- -->';
ok($ret, $right_ret);
