package Tags::Output;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
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

# Finalize Tags output.
sub finalize {
	my $self = shift;
	while (@{$self->{'printed_tags'}}) {
		$self->put(['e', $self->{'printed_tags'}->[0]]);
	}
	return;
}

# Flush tags in object.
sub flush {
	my ($self, $reset_flag) = @_;
	my $ouf = $self->{'output_handler'};
	my $ret;
	if (ref $self->{'flush_code'} eq 'ARRAY') {
		$ret = join $self->{'output_sep'}, @{$self->{'flush_code'}};
	} else {
		$ret = $self->{'flush_code'};
	}

	# Output callback.
	$self->_process_callback(\$ret, 'output_callback');

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

# Return array of opened tags.
sub open_tags {
	my $self = shift;
	return @{$self->{'printed_tags'}};
}

# Put tags code.
sub put {
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
			if ($self->{'strict_instruction'}) {
				$self->_check_arguments(\@tags_struct, 1, 2);
			}
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

# Reset.
sub reset {
	my $self = shift;

	# Flush code.
	$self->_reset_flush;

	# Printed tags.
	$self->{'printed_tags'} = [];

	return;
}

# Check arguments.
sub _check_arguments {
	my ($self, $tags_struct_ar, $min_arg_num, $max_arg_num) = @_;
	my $arg_num = scalar @{$tags_struct_ar};
	if ($arg_num < $min_arg_num || $arg_num > $max_arg_num) {
		err 'Bad number of arguments.', 
			'\'Tags\' structure', join ', ', @{$tags_struct_ar};
	}
	return;
}

# Check parameters to rigth values.
sub _check_params {
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

# Default parameters.
sub _default_parameters {
	my $self = shift;

	# Auto-flush.
	$self->{'auto_flush'} = 0;

	# Output callback.
	$self->{'output_callback'} = undef;

	# Set output handler.
	$self->{'output_handler'} = undef;

	# Output separator.
	$self->{'output_sep'} = "\n";

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# Strict instruction.
	$self->{'strict_instruction'} = 1;

	return;
}

# Process dala callback.
sub _process_callback {
	my ($self, $data_r, $callback_type) = @_;

	# Process data callback.
	if (defined $self->{$callback_type}
		&& ref $self->{$callback_type} eq 'CODE') {

		$self->{$callback_type}->($data_r);
	}

	return;
}

# Attributes.
sub _put_attribute {
	my ($self, $attr, $value) = @_;
	push @{$self->{'flush_code'}}, 'Attribute';
	return;
}

# Begin of tag.
sub _put_begin_of_tag {
	my ($self, $tag) = @_;
	push @{$self->{'flush_code'}}, 'Begin of tag';
	return;
}

# CData.
sub _put_cdata {
	my ($self, @cdata) = @_;
	push @{$self->{'flush_code'}}, 'CData';
	return;
}

# Comment.
sub _put_comment {
	my ($self, @comments) = @_;
	push @{$self->{'flush_code'}}, 'Comment';
	return;
}

# Data.
sub _put_data {
	my ($self, @data) = @_;
	push @{$self->{'flush_code'}}, 'Data';
	return;
}

# End of tag.
sub _put_end_of_tag {
	my ($self, $tag) = @_;
	push @{$self->{'flush_code'}}, 'End of tag';
	return;
}

# Instruction.
sub _put_instruction {
	my ($self, $target, $code) = @_;
	push @{$self->{'flush_code'}}, 'Instruction';
	return;
}

# Raw data.
sub _put_raw {
	my ($self, @raw_data) = @_;
	push @{$self->{'flush_code'}}, 'Raw data';
	return;
}

# Reset flush code.
sub _reset_flush {
	my $self = shift;
	$self->{'flush_code'} = [];
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags::Output - Base class for Tags::Output::*.

=head1 SYNOPSIS

 use Tags::Output;
 my $obj = Tags::Output->new(%parameters);
 $obj->finalize;
 my $ret = $obj->flush($reset_flag);
 my @tags = $obj->open_tags;
 $obj->put(@data);
 $obj->reset;

=head1 METHODS

=over 8

=item C<new(%parameters)>

=over 8

=item * C<auto_flush>

 Auto flush flag.
 Default value is 0.

=item * C<output_callback>

 Output callback.
 Default value is undef.

=item * C<output_handler>

 Set output handler.
 Default value is undef.

=item * C<output_sep>

 Output separator.
 Default value is newline.

=item * C<skip_bad_tags>

 Skip bad tags.
 Default value is 0.

=item * C<strict_instruction>

 Strict instruction.
 Default value is 1.

=back

=item C<finalize()>

 Finalize Tags output.
 Automaticly puts end of all opened tags.
 Returns undef.

=item C<flush($reset_flag)>

 Flush tags in object.
 If defined 'output_handler' flush to its.
 Or return code.
 If enabled $reset_flag, then resets internal variables via reset method.

=item C<open_tags()>

 Return array of opened tags.

=item C<put(@data)>

 Put tags code in tags format.
 Returns undef.

=item C<reset($reset_flag)>

 Resets internal variables.
 Returns undef.

=back

=head1 ERRORS

 new():
         Auto-flush can't use without output handler.
         Output handler is bad file handler.
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

 flush():
         Cannot write to output handler.

 put():
         Bad data.
         Bad type of data.
         Bad number of arguments. 'Tags' structure %s

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags::Output;

 # Object.
 my $tags = Tags::Output->new;

 # Put all tag types.
 $tags->put(
         ['b', 'tag'],
         ['a', 'par', 'val'],
         ['c', 'data', \'data'],
         ['e', 'tag'],
         ['i', 'target', 'data'],
         ['b', 'tag'],
         ['d', 'data', 'data'],
         ['e', 'tag'],
 );

 # Print out.
 print $tags->flush."\n";

 # Output:
 # Begin of tag
 # Attribute
 # Comment
 # End of tag
 # Instruction
 # Begin of tag
 # Data
 # End of tag

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>.

=head1 SEE ALSO

L<Tags>,
L<Tags::Output::PYX>,
L<Tags::Output::Raw>,
L<Tags::Utils>.

=head1 REPOSITORY

L<https://github.com/tupinek/Tags>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
