# $Id: 01_version.t,v 1.1 2008-07-30 22:43:44 skim Exp $

print "Testing: Version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.01');
