package Tags;

# Pragmas.
use strict;
use warnings;

# Version.
our $VERSION = 0.03;

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags - Structure oriented SGML/XML/HTML/etc. elements manipulation.

=head1 STRUCTURE

 Perl structure:

 Reference to array.
 [type, data]

 Types:
 a  - Tag attribute.
 b  - Begin of tag.
 c  - Comment section.
 cd - Cdata section.
 d  - Data section.
 e  - End of tag.
 i  - Instruction section.
 r  - Raw section.

 Data:
 a - $attr, $value
 b - $element
 c - @comment
 cd - @cdata
 d - @data
 e - $element
 i - $target, $code
 r - @raw_data

=head1 SEE ALSO

L<Tags::Output>,
L<Tags::Output::PYX>,
L<Tags::Output::Raw>,
L<Tags::Process::EntitySubstitute>,
L<Tags::Process::Id>,
L<Tags::Process::Validator>,
L<Tags::Utils::Preserve>.

=head1 REPOSITORY

L<https://github.com/tupinek/Tags>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD 2-Clause License

=head1 VERSION 

0.01

=cut
