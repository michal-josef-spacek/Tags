# $Id: 01_version.t,v 1.4 2008-04-18 17:01:52 skim Exp $

print "Testing: Version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.05');
