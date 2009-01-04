#!/usr/bin/perl

# Pragmas.
use strict;
use warnings;

# Modules.
use Tags2::Utils::Preserve;
use Test::More;

# Global variables.
use vars qw/$debug $class $dir/;

BEGIN {
	# Name of class.
	$dir = $class = 'Tags2::Utils::Preserve';
	$dir =~ s/:://g;

	my $tests = `egrep -r \"^[[:space:]]*ok\\(\" t/$dir/*.t | wc -l`;
	chomp $tests;
	my $tmp = `egrep -r \"^[[:space:]]*is\\(\" t/$dir/*.t | wc -l`;
	chomp $tmp;
	$tests += $tmp;
	$tmp = `egrep -r \"^[[:space:]]*is_deeply\\(\" t/$dir/*.t | wc -l`;
	chomp $tmp;
	$tests += $tmp;
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
