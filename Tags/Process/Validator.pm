package Tags::Process::Validator;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use List::MoreUtils qw(any none);
use XML::DTDParser qw(ParseDTDFile);

# Version.
our $VERSION = 0.01;

# TODO
# a) Overit, jestli jsou #REQUIRED atributy pouzity.
# b) Overit, jestli jsou spravne data (simple tag, nebo tag s daty).

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# DTD structure.
	$self->{'dtd'} = undef;

	# DTD file.
	$self->{'dtd_file'} = undef;

	# Process params.
	set_params($self, @params);

	# Is exists 'dtd_file' name.
	if (! $self->{'dtd_file'}) {
		err 'Cannot read file with DTD defined by \'dtd_file\' '.
			'parameter.';
	}

	# Is 'dtd_file' readable.
	if (! -r $self->{'dtd_file'}) {
	 	err "Cannot read file '$self->{'dtd_file'}' with DTD.";
	}

	# DTD structure.
	if (! $self->{'dtd'}) {
		$self->{'dtd'} = ParseDTDFile($self->{'dtd_file'});
	}

	# Initialization.
	$self->reset;

	# Object.
	return $self;
}

# Check structure opposite dtd struct.
sub check {
	my ($self, @data) = @_;
	foreach my $dat (@data) {
		$self->check_one($dat);
	}
	return;
}

# Detect and process one tag.
sub check_one {
	my ($self, $data) = @_;

	# Check required attributes.
	if ($data->[0] ne 'a' && $self->{'check_req_attr'}) {

		# Actual tag.
		my $tag = $self->{'printed'}->[0];

		# For each required attributes check.
		foreach my $req ($self->_get_required_attr($tag)) {
			if (! scalar @{$self->{'printed_attr'}}
				|| none { $req eq $_ }
				@{$self->{'printed_attr'}}) {

				err "Missing required attribute '$req' ".
					"at tag '$tag'.";
			}
		}

		# Cleat flag.
		$self->{'check_req_attr'} = 0;

		# Clear tag attributes stack.
		$self->{'printed_attr'} = [];
	}

	# Attributes.
	if ($data->[0] eq 'a') {
		my @tmp_data = @{$data};
		shift @tmp_data;

		# Actual tag.
		my $tag = $self->{'printed'}->[0];

		# For all attributes.
		while (@tmp_data) {
			my $attr = shift @tmp_data;
			my $val = shift @tmp_data;

			# Check to duplicit attribute.
			if (scalar @{$self->{'printed_attr'}}
				&& any { $attr eq $_ }
				@{$self->{'printed_attr'}}) {

				err "Attribute '$attr' at tag '$tag' is ".
					'duplicit.';
			}

			# Attributes of printed tag.
			my @tag_attributes = keys %{$self->{'dtd'}->{$tag}
				->{'attributes'}};

			# Check to attribute exist.
			if (scalar @tag_attributes
				&& none { $attr eq $_ } @tag_attributes) {

				err "Bad attribute '$attr' at tag '$tag'.";
			}

			# Control default values.
			if (ref $self->{'dtd'}->{$tag}->{'attributes'}
				->{$attr}->[3] eq 'ARRAY'
				&& scalar
				@{$self->{'dtd'}->{$tag}->{'attributes'}
				->{$attr}->[3]}
				&& none { $val eq $_ }
				@{$self->{'dtd'}->{$tag}->{'attributes'}
				->{$attr}->[3]}) {

				err "Bad value '$val' of attribute '$attr' ".
					"at tag '$tag'.";
			}

			# Add parameter to atribute stack.
			unshift @{$self->{'printed_attr'}}, $attr;
		}

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		my $tag = $data->[1];

		# Tag non exists in dtd.
		if (! exists $self->{'dtd'}->{$tag}) {
			err "Tag '$tag' doesn't exist in dtd.";
		}

		# First tag.
		if (! scalar @{$self->{'printed'}}) {

			# Error with parent.
			if (exists $self->{'dtd'}->{$tag}->{'parent'}) {
				err "Tag '$tag' cannot be first.";
			}

		# Normal tag.
		} else {
			if (! exists $self->{'dtd'}->{$tag}->{'parent'}) {
				err "Tag '$tag' cannot be after other tag.";
			}

			my $prev_tag = $self->{'printed'}->[0];
			if (scalar @{$self->{'dtd'}->{$tag}->{'parent'}}
				&& none { $prev_tag eq $_ }
				@{$self->{'dtd'}->{$tag}->{'parent'}}) {

				err "Tag '$tag' cannot be after tag ".
					"'$prev_tag'.";
			}
		}

		# Check to missing tags.
# TODO Je to spatne.
#		$self->_check_missing($tag);

		# Printed.
		unshift @{$self->{'printed'}}, $tag;

		# Check required attributes flag.
		$self->{'check_req_attr'} = 1;

		# Initialization value of children tags.
		unshift @{$self->{'children_tags'}}, -1;

	# End of tag.
	} elsif ($data->[0] eq 'e') {

		# Check to missing tags.
# TODO Je to spatne.
#		$self->_check_missing;

		# TODO Pouze u xml.
		shift @{$self->{'printed'}};
		shift @{$self->{'children_tags'}};

	# Data.
	} elsif ($data->[0] eq 'd') {

		# Actual tag.
		my $tag = $self->{'printed'}->[0];

		# Check to possibility of data in this tag.
		if (! exists $self->{'dtd'}->{$tag}->{'content'}) {
			err "Bad data section in tag '$tag'.";
		}
	}

	return;
}

# Resets object.
sub reset {
	my $self = shift;

	# Check required attributes flag.
	$self->{'check_req_attr'} = 0;

	# Children tags stack.
	$self->{'children_tags'} = [];

	# Tags stack.
	$self->{'printed'} = [];

	# Tag attributes stack.
	$self->{'printed_attr'} = [];

	return;
}

# Check to missing tags.
sub _check_missing {
	my ($self, $tag) = @_;

	# Previous tag.
	my $prev_tag = $self->{'printed'}->[0];

	# No previous tag.
	if (! $prev_tag) {
		return;
	}

	# Without children.
	if (! exists $self->{'dtd'}->{$prev_tag}->{'children'}) {
		return;
	}

	# No other tags.
	my $index = $self->{'children_tags'}->[0] + 1;
	if ($index > $#{$self->{'dtd'}->{$prev_tag}->{'childrenARR'}}) {
		return;
	}

	# Check to missing tags.
	if ($tag && $self->{'dtd'}->{$prev_tag}->{'childrenARR'}
		->[$index] eq $tag) {

		$self->{'children_tags'}->[0]++;
	} else {
		my $missing = $self->{'dtd'}->{$prev_tag}->{'childrenARR'}
			->[$index];
		err "Missing tag '$missing' at tag '$prev_tag'.";
	}
	return;
}

# Get required attributes.
sub _get_required_attr {
	my ($self, $tag) = @_;
	my $attr = $self->{'dtd'}->{$tag}->{'attributes'};
	my @keys = keys %{$attr};
	return grep { $attr->{$_}->[1] eq '#REQUIRED' } @keys;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags::Process::Validator - Validator class for 'Tags' structure.

=head1 SYNOPSIS

 use Tags::Process::Validator;
 my $v = Tags::Process::Validator(%params);
 $v->check(@data);
 $v->check_one($data);
 $v->reset;

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item C<dtd>

 DTD structure.

=item C<dtd_file>

 DTD file.
 Constructor reads DTD file, and structure saves to 'dtd' param.

=back

=item C<check(@data)>

 TODO

=item C<check_one($data)>

 TODO

=item C<reset()>

 Resets object.

=back

=head1 ERRORS

 Mine:
   Attribute '%s' at tag '%s' is duplicit.
   Bad attribute '%s' at tag '%s'.
   Bad data section in tag '%s'.
   Bad value '%s' of attribute '%s' at tag '%s'.
   Cannot read file '%s' with DTD.
   Cannot read file with DTD defined by 'dtd_file' paremeter.
   Missing required attribute '%s' at tag '%s'.
   Tag '%s' cannot be first.
   Tag '%s' cannot be after other tag.
   Tag '%s' cannot be after tag '%s'.
   Tag '%s' doesn't exist in dtd.

 From Class::Utils:
   Unknown parameter '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags::Process::Validator;

 TODO

=head1 DEPENDENCIES

L<Class::Utils(3pm)>,
L<Error::Pure(3pm)>.

=head1 SEE ALSO

L<Tags(3pm)>,
L<Tags::Output::Core(3pm)>,
L<Tags::Output::Raw(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
