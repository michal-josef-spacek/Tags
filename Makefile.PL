# $Id: Makefile.PL,v 1.4 2007-01-24 12:07:03 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple' => 0.02,
	},
	'VERSION' => 0.01,
);
