#!/usr/bin/perl
# $Id: 06_tags2_process_id.t,v 1.1 2008-07-30 11:14:53 skim Exp $

# Pragmas.
use strict;
use warnings;

# Modules.
use Tags2::Process::Id;
use Test;

# Global variables.
use vars qw/$debug $class $dir/;

BEGIN {
	# Name of class.
	$dir = $class = 'Tags2::Process::Id';
	$dir =~ s/:://g;

	my $tests = `egrep -r \"^[[:space:]]*ok\\(\" t/$dir/*.t | wc -l`;
        chomp $tests;
        plan('tests' => $tests);

        # Debug.
        $debug = 1;
}

# Prints debug information about class.
print "\nClass '$class'\n" if $debug;

# For every test for this Class.
my @list = `ls t/$dir/*.t`;
foreach (@list) {
        chomp;
        do $_;
	print $@;
}

