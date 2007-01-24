# $Id: Makefile.PL,v 1.5 2007-01-24 12:12:28 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.02,
	},
	'VERSION' => 0.01,
);
