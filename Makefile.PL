# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Špaček <skim@cpan.org>',
	'NAME' => 'Tags',
	'PREREQ_PM' => {
		'Class::Utils' => 0.01,
		'Error::Simple::Multiple' => 0.05,
		'File::Object' => 0,
		'List::MoreUtils' => 0,
		'Readonly' => 0,
	},
	'VERSION' => 0.01,
	'test' => {
		'TESTS' => 't/Tags::Output::Core/*.t '.
			't/Tags::Output::ESIS/*.t '.
			't/Tags::Output::Indent/*.t '.
			't/Tags::Output::Indent2/*.t '.
			't/Tags::Output::LibXML/*.t '.
			't/Tags::Output::PYX/*.t '.
			't/Tags::Output::Raw/*.t '.
			't/Tags::Output::SESIS/*.t '.
			't/Tags::Process::EntitySubstitute/*.t '.
			't/Tags::Process::Id/*.t '.
			't/Tags::Process::Validator/*.t '.
			't/Tags::Utils/*.t '.
			't/Tags::Utils::Preserve/*.t',
	},
);
