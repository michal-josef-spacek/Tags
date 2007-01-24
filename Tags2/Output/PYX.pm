#------------------------------------------------------------------------------
package Tags2::Output::PYX;
#------------------------------------------------------------------------------
# $Id: PYX.pm,v 1.2 2007-01-24 13:57:13 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new($) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Set output handler.
	$self->{'output_handler'} = *STDOUT;

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." unless exists $self->{$key};
                $self->{$key} = $val;
        }

	# Flush code.
	$self->{'flush_code'} = ();

	# Tmp code.
	$self->{'tmp_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub flush($) {
#------------------------------------------------------------------------------
# Flush tags in object.

	my $self = shift;
	my $ouf = $self->{'output_handler'};
	print $ouf join("\n", @{$self->{'flush_code'}});
}

#------------------------------------------------------------------------------
sub open_tags($) {
#------------------------------------------------------------------------------
# Return array of opened tags.

	my $self = shift;
	return @{$self->{'printed_tags'}};
}

#------------------------------------------------------------------------------
sub finalize($) {
#------------------------------------------------------------------------------
# Finalize Tags output.

	my $self = shift;
	while ($#{$self->{'printed_tags'}} != -1) {
		$self->put(['e', shift @{$self->{'printed_tags'}}]);
	}
}

#------------------------------------------------------------------------------
sub put($@) {
#------------------------------------------------------------------------------
# Put tags code.

	my $self = shift;
	my @data = @_;

	# For every data.
	foreach my $dat (@data) {

		# Bad data.
		unless (ref $dat eq 'ARRAY') {
			err "Bad data.";
		}

		# Detect and process data.
		$self->_detect_data($dat);
	}
}

#------------------------------------------------------------------------------
sub reset($) {
#------------------------------------------------------------------------------
# Resets internal variables.

	my $self = shift;
	$self->{'printed_tags'} = [];
	$self->{'flush_code'} = ();
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _detect_data($$) {
#------------------------------------------------------------------------------
# Detect and process data.

	my ($self, $data) = @_;

	# Attributes.
	if ($data->[0] eq 'a') {
		shift @{$data};
		while (@{$data}) {
			my $par = shift @{$data};
			my $val = shift @{$data};
			push @{$self->{'flush_code'}}, "A$par $val";
		}

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		push @{$self->{'flush_code'}}, "($data->[1]";
		unshift @{$self->{'printed_tags'}}, $data->[1];

	# Comment.
	} elsif ($data->[0] eq 'c') {
		shift @{$data};
		my $tmp_data = '';
		foreach my $d (@{$data}) {
			$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
		}
		push @{$self->{'flush_code'}}, 
			'C'.$self->_encode_newline($tmp_data);

	# Data.
	} elsif ($data->[0] eq 'd') {
		shift @{$data};
		my $tmp_data = '';
		foreach my $d (@{$data}) {
			$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
		}
		push @{$self->{'flush_code'}}, 
			'-'.$self->_encode_newline($tmp_data);

	# End of tag.
	} elsif ($data->[0] eq 'e') {
		my $printed = shift @{$self->{'printed_tags'}};
		unless ($printed eq $data->[1]) {
			err "Ending bad tag: '$data->[1]' in block of ".
				"tag '$printed'.";
		}
		push @{$self->{'flush_code'}}, ")$data->[1]";

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		shift @{$data};
		my $target = shift @{$data};
		my $tmp_data = '';
		while (@{$data}) {
			my $data = shift @{$data};
			$tmp_data .= " $data";
		}
		push @{$self->{'flush_code'}}, 
			"?$target ".$self->_encode_newline($tmp_data);

	# Raw data.
	} elsif ($data->[0] eq 'r') {
		shift @{$data};
		while (@{$data}) {
			my $data = shift @{$data};
			push @{$self->{'flush_code'}}, 
				'R'.$self->_encode_newline($data);
		}

	# Other.
	} else {
		err "Bad type of data.";
	}
}

#------------------------------------------------------------------------------
sub _encode_newline($$) {
#------------------------------------------------------------------------------
# Encode newline in data to '\n' in output.

	my ($self, $string) = @_;
	my @tmp_data = split(/\n/, $string);
	return join('\n', @tmp_data);
}

1;
