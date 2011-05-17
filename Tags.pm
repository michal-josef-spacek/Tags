1;

=pod

=encoding utf8

=head1 NAME

 Tags - Overview about 'Tags' classes.

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

L<Tags::Output::Core(3pm)>,
L<Tags::Output::ESIS(3pm)>,
L<Tags::Output::Indent(3pm)>,
L<Tags::Output::Indent2(3pm)>,
L<Tags::Output::LibXML(3pm)>,
L<Tags::Output::PYX(3pm)>,
L<Tags::Output::Raw(3pm)>,
L<Tags::Output::SESIS(3pm)>,
L<Tags::Process::EntitySubstitute(3pm)>,
L<Tags::Process::Id(3pm)>,
L<Tags::Process::Validator(3pm)>,
L<Tags::Utils::Preserve(3pm)>,
L<Tags::Utils::Simple(3pm)>,
L<Tags::Utils::SimpleOO(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 VERSION 

0.01

=cut
