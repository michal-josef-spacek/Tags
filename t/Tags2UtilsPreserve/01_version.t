print "Testing: Version.\n" if $debug;
is(eval('$'.$class.'::VERSION'), '0.01');
