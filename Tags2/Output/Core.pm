#------------------------------------------------------------------------------
package Tags2::Output::Core;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};

# Version.
our $VERSION = 0.02;

#------------------------------------------------------------------------------
sub finalize {
#------------------------------------------------------------------------------
# Finalize Tags output.

	my $self = shift;
	while (@{$self->{'printed_tags'}}) {
		$self->put(['e', $self->{'printed_tags'}->[0]]);
	}
	return;
}

#------------------------------------------------------------------------------
sub flush {
#------------------------------------------------------------------------------
# Flush tags in object.

	my ($self, $reset_flag) = @_;
	my $ouf = $self->{'output_handler'};
	my $ret;
	if (ref $self->{'flush_code'} eq 'ARRAY') {
		my $output_sep = $self->{'output_sep'}
			? $self->{'output_sep'}
			: "\n";
		$ret = join($output_sep, @{$self->{'flush_code'}});
	} else {
		$ret = $self->{'flush_code'};
	}
	if ($ouf) {
		print {$ouf} $ret || err 'Cannot write to output handler.';
		undef $ret;
	}

	# Reset.
	if ($reset_flag) {
		$self->reset;
	}

	# Return string.
	return $ret;
}

#------------------------------------------------------------------------------
sub open_tags {
#------------------------------------------------------------------------------
# Return array of opened tags.

	my $self = shift;
	return @{$self->{'printed_tags'}};
}

#------------------------------------------------------------------------------
sub put {
#------------------------------------------------------------------------------
# Put tags code.

	my ($self, @data) = @_;

	# For every data.
	foreach my $tags_structure_ref (@data) {

		# Bad data.
		if (ref $tags_structure_ref ne 'ARRAY') {
			err 'Bad data.';
		}

		# Split to flag and main tags structure.
		my ($flag, @tags_struct) = @{$tags_structure_ref};

		# Attributes.
		if ($flag eq 'a') {
			$self->_put_attribute(@tags_struct);

		# Begin of tag.
		} elsif ($flag eq 'b') {
			$self->_put_begin_of_tag(@tags_struct);

		# CData.
		} elsif ($flag eq 'cd') {
			$self->_put_cdata(@tags_struct);

		# Comment.
		} elsif ($flag eq 'c') {
			$self->_put_comment(@tags_struct);

		# Data.
		} elsif ($flag eq 'd') {
			$self->_put_data(@tags_struct);

		# End of tag.
		} elsif ($flag eq 'e') {
			$self->_put_end_of_tag(@tags_struct);

		# Instruction.
		} elsif ($flag eq 'i') {
			$self->_put_instruction(@tags_struct);

		# Raw data.
		} elsif ($flag eq 'r') {
			$self->_put_raw(@tags_struct);

		# Other.
		} else {
			if (! $self->{'skip_bad_tags'}) {
				err 'Bad type of data.';
			}
		}
	}

	# Auto-flush.
	if ($self->{'auto_flush'}) {
		$self->flush;
		$self->{'flush_code'} = $EMPTY_STR;
	}

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _process_callback {
#------------------------------------------------------------------------------
# Process dala callback.

	my ($self, $data_array_ref, $callback_type) = @_;

	# Process data callback.
	if (defined $self->{$callback_type}
		&& ref $self->{$callback_type} eq 'CODE') {

		$self->{$callback_type}->($data_array_ref);
	}

	return;
}

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, $attr, $value) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $tag) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @data) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $target, $code) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, @raw_data) = @_;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::Core - Base class for Tags2::Output::*.

=head1 SYNOPSIS

 TODO

=head1 METHODS

=over 8

=item B<finalize()>

 TODO

=item B<flush($reset_flag)>

 TODO

=item B<open_tags()>

 TODO

=item B<put(@data)>

 TODO

=back

=head1 ERRORS

 Bad data.
 Bad type of data.
 Cannot write to output handler.

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::Indent2(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::PYX(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::SESIS(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.02

=cut
