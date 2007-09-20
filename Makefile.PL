# $Id: Makefile.PL,v 1.7 2007-09-20 17:27:02 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.03,
	},
	'VERSION' => 0.03,
);
