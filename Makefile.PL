# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Tags2',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.04,
		'List::MoreUtils' => 0,
		'Readonly' => 0,
	},
	'VERSION' => 0.04,
);
