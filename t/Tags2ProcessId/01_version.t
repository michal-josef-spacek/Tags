# $Id: 01_version.t,v 1.1 2008-07-30 11:14:52 skim Exp $

print "Testing: Version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.01');
