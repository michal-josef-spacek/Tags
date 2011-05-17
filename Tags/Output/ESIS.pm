package Tags2::Output::ESIS;

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
our $VERSION = 0.02;

# Resets internal variables.
sub reset {
	my $self = shift;

	# Reset from SUPER.
	$self->SUPER::reset();

	# Tmp code.
	$self->{'tmp_code'} = [];

	return;
}

# Flush tmp.
sub _flush_tmp {
	my $self = shift;
	if ($self->{'tmp_code'}) {
		push @{$self->{'flush_code'}}, @{$self->{'tmp_code'}};
		$self->{'tmp_code'} = [];
	}
	return;
}

# Attributes.
sub _put_attribute {
	my ($self, $attr, $value) = @_;
	push @{$self->{'flush_code'}}, "A$attr $value";
	return;
}

# Begin of tag.
sub _put_begin_of_tag {
	my ($self, $tag) = @_;
	push @{$self->{'tmp_code'}}, "($tag";
	unshift @{$self->{'printed_tags'}}, $tag;
	return;
}

# CData.
sub _put_cdata {
	my ($self, @cdata) = @_;
	$self->_put_data(@cdata);
	return;
}

# Comment.
sub _put_comment {
	my ($self, @comments) = @_;
	$self->_flush_tmp;
	my $comment = join $EMPTY_STR, @comments;
	push @{$self->{'flush_code'}}, '_'.encode_newline($comment);
	return;
}

# Data.
sub _put_data {
	my ($self, @data) = @_;
	$self->_flush_tmp;
	my $data = join $EMPTY_STR, @data;
	push @{$self->{'flush_code'}}, q{-}.encode_newline($data);
	return;
}

# End of tag.
sub _put_end_of_tag {
	my ($self, $tag) = @_;
	$self->_flush_tmp;
	my $printed = shift @{$self->{'printed_tags'}};
	if ($printed ne $tag) {
		err "Ending bad tag: '$tag' in block of tag '$printed'.";
	}
	push @{$self->{'flush_code'}}, ")$tag";
	return;
}

# Instruction.
sub _put_instruction {
	my ($self, $target, $code) = @_;
	$self->_flush_tmp;
	my $instruction = q{?}.$target;
	if ($code) {
		$instruction .= $SPACE.$code;
	}
	push @{$self->{'flush_code'}}, encode_newline($instruction);
	return;
}

# Raw data.
sub _put_raw {
	my ($self, @raw_data) = @_;
	$self->_put_data(@raw_data);
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

=item C<new(%parameters)>

 TODO

=over 8

=item C<output_handler>

 TODO

=item C<skip_bad_data>

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

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
