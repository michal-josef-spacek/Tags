# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.05,
		'List::MoreUtils' => 0,
		'Readonly' => 0,
	},
	'VERSION' => 0.04,
);
