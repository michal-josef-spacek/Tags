# $Id: 01_version.t,v 1.1 2007-09-10 17:43:24 skim Exp $

print "Testing: Version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.02');
