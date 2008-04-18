# $Id: Makefile.PL,v 1.9 2008-04-18 15:57:49 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.04,
	},
	'VERSION' => 0.04,
);
