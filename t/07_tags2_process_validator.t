#!/usr/bin/perl
# $Id: 07_tags2_process_validator.t,v 1.2 2008-08-16 19:35:01 skim Exp $

# Pragmas.
use strict;
use warnings;

# Modules.
use Tags2::Process::Validator;
use Test;

# Global variables.
use vars qw/$debug $class $dir/;

BEGIN {
	# Name of class.
	$dir = $class = 'Tags2::Process::Validator';
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
