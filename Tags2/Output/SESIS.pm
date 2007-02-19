#------------------------------------------------------------------------------
package Tags2::Output::SESIS;
#------------------------------------------------------------------------------
# $Id: SESIS.pm,v 1.3 2007-02-19 23:56:52 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new($@) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Set output handler.
	$self->{'output_handler'} = *STDOUT;

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

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
			'_'.$self->_encode_newline($tmp_data);

	# CData.
	} elsif ($data->[0] eq 'cd') {
		shift @{$data};
		my $tmp_data = '';
		foreach my $d (@{$data}) {
			$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
		}
		push @{$self->{'flush_code'}}, 
			'CD'.$self->_encode_newline($tmp_data);

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
		my $tmp_data = '';
		while (@{$data}) {
			my $data = shift @{$data};
			$tmp_data .= $data;
		}
		push @{$self->{'flush_code'}}, 
			'R'.$self->_encode_newline($tmp_data);

	# Other.
	} else {
		err "Bad type of data." unless $self->{'skip_bad_tags'};
	}
}

#------------------------------------------------------------------------------
sub _encode_newline($$) {
#------------------------------------------------------------------------------
# Encode newline in data to '\n' in output.

	my ($self, $string) = @_;
	$string =~ s/\n/\\n/g;
	return $string;
}

1;

=pod

=head1 NAME

 Tags2::Output::SESIS - S(kim) ESIS class for line oriented output for Tags2.

=head1 SYNOPSYS

 TODO

=head1 SESIS LINE CHARS

 R  - Raw data.
 _  - Commen data.
 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 CD - Cdata.
 -  - Normal data.

=head1 METHODS

=over 8

=item B<new()>

 TODO

=head2 PARAMETERS

=over 8

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

=head1 REQUIREMENTS

 L<Error::Simple::Multiple>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
