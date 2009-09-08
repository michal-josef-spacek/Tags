#------------------------------------------------------------------------------
package Tags2::Output::PYX;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Readonly;
use Tags2::Utils qw(encode_newline);

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, $attr, $value) = @_;
	push @{$self->{'flush_code'}}, "A$attr $value";
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $tag) = @_;
	push @{$self->{'flush_code'}}, "($tag";
	unshift @{$self->{'printed_tags'}}, $tag;
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;
	$self->_put_data(@cdata);
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;
	$self->_put_data(
		map { '<!--'.$_.'-->' } @comments,
	);
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @data) = @_;
	my $data = join($EMPTY_STR, @data);
	push @{$self->{'flush_code'}}, '-'.encode_newline($data);
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	my $printed = shift @{$self->{'printed_tags'}};
	if ($printed ne $tag) {
		err "Ending bad tag: '$tag' in block of tag '$printed'.";
	}
	push @{$self->{'flush_code'}}, ")$tag";
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $target, $code) = @_;

	# Construct instruction line.
	my $instruction = '?'.$target;
	if ($code) {
		$instruction .= $SPACE.$code;
	}

	# To flush code.
	push @{$self->{'flush_code'}}, encode_newline($instruction);

	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, @raw_data) = @_;
	$self->_put_data(@raw_data);
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::PYX - PYX class for line oriented output for 'Tags2'.

=head1 SYNOPSYS

 TODO

=head1 PYX LINE CHARS

 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 -  - Normal data.

=head1 METHODS

=over 8

=item C<new()>

 TODO

=over 8

=item * C<auto_flush>

 Auto flush flag.
 Default is 0.

=item * C<output_handler>

 TODO

=item * C<output_sep>

 TODO

=item * C<skip_bad_data>

 TODO

=back

=item C<finalize()>

 TODO

=item C<flush()>

 TODO

=item C<open_tags()>

 TODO

=item C<put()>

 TODO

=item C<reset()>

 TODO

=back

=head1 ERRORS

 Mine:
   Ending bad tag: '%s' in block of tag '%s'.
   Unknown parameter '%s'.

=head1 EXAMPLE

 TODO

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>,
L<Tags2::Utils(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Core(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::Indent2(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::SESIS(3pm)>,
L<Tags2::Utils(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
