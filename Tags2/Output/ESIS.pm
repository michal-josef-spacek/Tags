#------------------------------------------------------------------------------
package Tags2::Output::ESIS;
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

# Version.
our $VERSION = 0.02;

#------------------------------------------------------------------------------
sub reset {
#------------------------------------------------------------------------------
# Resets internal variables.

	my $self = shift;

	# Reset from SUPER.
	$self->SUPER::reset();

	# Tmp code.
	$self->{'tmp_code'} = [];

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _flush_tmp {
#------------------------------------------------------------------------------
# Flush tmp.

	my $self = shift;
	if ($self->{'tmp_code'}) {
		push @{$self->{'flush_code'}}, @{$self->{'tmp_code'}};
		$self->{'tmp_code'} = [];
	}
	return;
}

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
	push @{$self->{'tmp_code'}}, "($tag";
	unshift @{$self->{'printed_tags'}}, $tag;
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;
	# TODO Implement.
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;
	$self->_flush_tmp;
	my $comment = join $EMPTY_STR, @comments;
	push @{$self->{'flush_code'}}, '_'.encode_newline($comment);
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @data) = @_;
	$self->_flush_tmp;
	my $data = join $EMPTY_STR, @data;
	push @{$self->{'flush_code'}}, '-'.encode_newline($data);
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	$self->_flush_tmp;
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
	$self->_flush_tmp;
	my $instruction = '?'.$target;
	if ($code) {
		$instruction .= ' '.$code;
	}
	push @{$self->{'flush_code'}}, encode_newline($instruction);
	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, $data_ref) = @_;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::ESIS - ESIS class for line oriented output for 'Tags2'.

=head1 SYNOPSYS

 TODO

=head1 ESIS LINE CHARS

 _  - Comment data.
 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 -  - Normal data.

=head1 METHODS

=over 8

=item B<new(%parameters)>

 TODO

=over 8

=item B<output_handler>

 TODO

=item B<skip_bad_data>

 TODO

=back

=item B<finalize()>

 TODO

=item B<flush()>

 TODO

=item B<open_tags()>

 TODO

=item B<put()>

 TODO

=item B<reset()>

 TODO

=back

=head1 EXAMPLE

 TODO

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>,
L<Tags2::Utils(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Core(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::Indent2(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::PYX(3pm)>,
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
