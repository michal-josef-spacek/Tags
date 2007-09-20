# $Id: 01_version.t,v 1.3 2007-09-20 21:21:47 skim Exp $

print "Testing: Version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.04');
