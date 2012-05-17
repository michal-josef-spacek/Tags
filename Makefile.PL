# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Structure oriented SGML/XML/HTML/etc. elements manipulation.';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Tags';
requires 'Class::Utils' => 0.02;
requires 'Error::Pure' => 0.07;
requires 'Exporter' => 0;
requires 'HTML::Entities' => 0;
requires 'Readonly' => 0;
resources 'repository' => {
	'url' => 'git://github.com/tupinek/Tags',
	'web' => 'https://github.com/tupinek/Tags',
	'type' => 'git',
};
test_requires 'English' => 0;
test_requires 'File::Object' => 0.03;
test_requires 'Test::More' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
