# $Id: Makefile.PL,v 1.1 2005-03-21 10:57:12 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'VERSION_FROM' => 'Tags2.pm',
	'PREREQ_PM' => {
		'XML::DTDParser' => 'skim_1.7',
	},
);
