#------------------------------------------------------------------------------
package Tags2::Output::Core;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Tags2::Utils qw(set_params);

# Version.
our $VERSION = 0.02;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Get default parameters.
	$self->_default_parameters;

	# Process params.
	set_params($self, @params);

	# Check parameters to right values.
	$self->_check_params;

	# Initialization.
	$self->reset;

	# Object.
	return $self;
}

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
		$ret = join $self->{'output_sep'}, @{$self->{'flush_code'}};
	} else {
		$ret = $self->{'flush_code'};
	}
	if ($ouf) {
		no warnings;
		print {$ouf} $ret or err 'Cannot write to output handler.';
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
	foreach my $tags_structure_ar (@data) {

		# Bad data.
		if (ref $tags_structure_ar ne 'ARRAY') {
			err 'Bad data.';
		}

		# Split to type and main tags structure.
		my ($type, @tags_struct) = @{$tags_structure_ar};

		# Attributes.
		if ($type eq 'a') {
			$self->_check_arguments(\@tags_struct, 1, 2);
			$self->_put_attribute(@tags_struct);

		# Begin of tag.
		} elsif ($type eq 'b') {
			$self->_check_arguments(\@tags_struct, 1, 1);
			$self->_put_begin_of_tag(@tags_struct);

		# CData.
		} elsif ($type eq 'cd') {
			$self->_put_cdata(@tags_struct);

		# Comment.
		} elsif ($type eq 'c') {
			$self->_put_comment(@tags_struct);

		# Data.
		} elsif ($type eq 'd') {
			$self->_put_data(@tags_struct);

		# End of tag.
		} elsif ($type eq 'e') {
			$self->_check_arguments(\@tags_struct, 1, 1);
			$self->_put_end_of_tag(@tags_struct);

		# Instruction.
		} elsif ($type eq 'i') {
			$self->_check_arguments(\@tags_struct, 1, 2);
			$self->_put_instruction(@tags_struct);

		# Raw data.
		} elsif ($type eq 'r') {
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
		$self->_reset_flush;
	}

	return;
}

#------------------------------------------------------------------------------
sub reset {
#------------------------------------------------------------------------------
# Reset.

	my $self = shift;

	# Flush code.
	$self->_reset_flush;

	# Printed tags.
	$self->{'printed_tags'} = [];

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _check_arguments {
#------------------------------------------------------------------------------
# Check arguments.

	my ($self, $tags_struct_ar, $min_arg_num, $max_arg_num) = @_;
	my $arg_num = scalar @{$tags_struct_ar};
	if ($arg_num < $min_arg_num || $arg_num > $max_arg_num) {
		err 'Bad number of arguments.', 
			'\'Tags2\' structure', join ', ', @{$tags_struct_ar};
	}
	return;
}

#------------------------------------------------------------------------------
sub _check_params {
#------------------------------------------------------------------------------
# Check parameters to rigth values.

        my $self = shift;

	# Check to output handler.
	if (defined $self->{'output_handler'}
		&& ref $self->{'output_handler'} ne 'GLOB') {

		err 'Output handler is bad file handler.';
	}

	# Check auto-flush only with output handler.
	if ($self->{'auto_flush'} && ! defined $self->{'output_handler'}) {
		err 'Auto-flush can\'t use without output handler.';
	}

	return;
}

#------------------------------------------------------------------------------
sub _default_parameters {
#------------------------------------------------------------------------------
# Default parameters.

	my $self = shift;

	# Auto-flush.
	$self->{'auto_flush'} = 0;

	# Set output handler.
	$self->{'output_handler'} = undef;

	# Output separator.
	$self->{'output_sep'} = "\n";

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	return;
}

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
	push @{$self->{'flush_code'}}, 'Attribute';
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $tag) = @_;
	push @{$self->{'flush_code'}}, 'Begin of tag';
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;
	push @{$self->{'flush_code'}}, 'CData';
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;
	push @{$self->{'flush_code'}}, 'Comment';
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @data) = @_;
	push @{$self->{'flush_code'}}, 'Data';
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	push @{$self->{'flush_code'}}, 'End of tag';
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $target, $code) = @_;
	push @{$self->{'flush_code'}}, 'Instruction';
	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, @raw_data) = @_;
	push @{$self->{'flush_code'}}, 'Raw data';
	return;
}

#------------------------------------------------------------------------------
sub _reset_flush {
#------------------------------------------------------------------------------
# Reset flush code.

	my $self = shift;
	$self->{'flush_code'} = [];
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

=item C<new(%parameters)>

=over 8

=item * C<auto_flush>

 TODO

=item * C<output_handler>

 TODO

=item * C<output_sep>

 TODO

=item * C<skip_bad_tags>

 TODO

=back

=item C<finalize()>

 TODO

=item C<flush($reset_flag)>

 TODO

=item C<open_tags()>

 TODO

=item C<put(@data)>

 TODO

=item C<reset($reset_flag)>

 TODO

=back

=head1 ERRORS

 Mine:
   Auto-flush can't use without output handler.
   Bad data.
   Bad number of arguments.
   Bad type of data.
   Cannot write to output handler.
   Output handler is bad file handler.

 From Tags2::Utils:
   Unknown parameter '%s'.

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Tags2::Utils(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
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

0.02

=cut
