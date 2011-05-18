# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Špaček <skim@cpan.org>',
	'NAME' => 'Tags',
	'PREREQ_PM' => {
		'Class::Utils' => 0.01,
		'Error::Pure' => 0.01,
		'File::Object' => 0,
		'Readonly' => 0,
	},
	'VERSION' => 0.01,
	'test' => {
		'TESTS' => 't/Tags/*.t '.
			't/Tags::Output::Core/*.t '.
			't/Tags::Output::Raw/*.t '.
			't/Tags::Process::EntitySubstitute/*.t '.
			't/Tags::Process::Id/*.t '.
			't/Tags::Process::Validator/*.t '.
			't/Tags::Utils/*.t '.
			't/Tags::Utils::Preserve/*.t',
	},
);
