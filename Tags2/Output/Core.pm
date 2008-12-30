#------------------------------------------------------------------------------
package Tags2::Output::Core;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY => q{};

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
	if ($ouf) {
		print {$ouf} $self->{'flush_code'};
	} else {
		$ret = $self->{'flush_code'};
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
	foreach my $dat (@data) {

		# Bad data.
		if (ref $dat ne 'ARRAY') {
			err 'Bad data.';
		}

		# Attributes.
		if ($dat->[0] eq 'a') {
			$self->_put_attribute($dat);

		# Begin of tag.
		} elsif ($dat->[0] eq 'b') {
			$self->_put_begin_of_tag($dat);

		# Comment.
		} elsif ($dat->[0] eq 'c') {
			$self->_put_comment($dat);

		# Data.
		} elsif ($dat->[0] eq 'd') {
			$self->_put_data($dat);

		# End of tag.
		} elsif ($dat->[0] eq 'e') {
			$self->_put_end_of_tag($dat);

		# Instruction.
		} elsif ($dat->[0] eq 'i') {
			$self->_put_instruction($dat);

		# Raw data.
		} elsif ($dat->[0] eq 'r') {
			$self->_put_raw($dat);

		# CData.
		} elsif ($dat->[0] eq 'cd') {
			$self->_put_cdata($dat);

		# Other.
		} else {
			err 'Bad type of data.' if ! $self->{'skip_bad_tags'};
		}
	}

	# Auto-flush.
	if ($self->{'auto_flush'}) {
		$self->flush;
		$self->{'flush_code'} = $EMPTY;
	}

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, $data_ref) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $data_ref) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, $data_ref) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, $data_ref) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, $data_ref) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $data_ref) = @_;
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $data_ref) = @_;
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
