# $Id: Makefile.PL,v 1.8 2008-01-29 20:17:35 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.04,
	},
	'VERSION' => 0.03,
);
