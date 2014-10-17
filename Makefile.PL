# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Structure oriented SGML/XML/HTML/etc. elements manipulation.';
author 'Michal Spacek <skim@cpan.org>';
license 'bsd';
name 'Tags';
readme_from 'Tags.pm';
requires 'Class::Utils' => 0.02;
requires 'Error::Pure' => 0.07;
requires 'Exporter' => 0;
requires 'HTML::Entities' => 0;
requires 'Readonly' => 0;
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Tags';
resources 'homepage' => 'https://github.com/tupinek/Tags';
resources 'repository' => 'git://github.com/tupinek/Tags';
test_requires 'English' => 0;
test_requires 'File::Object' => 0.03;
test_requires 'IO::Scalar' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.02';

# Run.
WriteAll();
