# $Id: Makefile.PL,v 1.6 2007-09-10 15:35:06 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.03,
	},
	'VERSION' => 0.02,
);
