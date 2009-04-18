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
	'test' => {
		'TESTS' => 't/Tags2::Output::Core/*.t '.
			't/Tags2::Output::ESIS/*.t '.
			't/Tags2::Output::Indent/*.t '.
			't/Tags2::Output::Indent2/*.t '.
			't/Tags2::Output::LibXML/*.t '.
			't/Tags2::Output::PYX/*.t '.
			't/Tags2::Output::Raw/*.t '.
			't/Tags2::Output::SESIS/*.t '.
			't/Tags2::Process::EntitySubstitute/*.t '.
			't/Tags2::Process::Id/*.t '.
			't/Tags2::Process::Validator/*.t '.
			't/Tags2::Utils/*.t '.
			't/Tags2::Utils::Preserve/*.t',
	},
);
