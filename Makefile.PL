# $Id: Makefile.PL,v 1.3 2005-09-26 18:43:03 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple' => 0.01,
	},
	'VERSION' => 0.01,
);
