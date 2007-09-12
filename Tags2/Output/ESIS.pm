#------------------------------------------------------------------------------
package Tags2::Output::ESIS;
#------------------------------------------------------------------------------
# $Id: ESIS.pm,v 1.5 2007-09-12 02:43:17 skim Exp $

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
	$self->{'output_handler'} = '';

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
sub finalize($) {
#------------------------------------------------------------------------------
# Finalize Tags output.

	my $self = shift;
	while ($#{$self->{'printed_tags'}} != -1) {
		$self->put(['e', shift @{$self->{'printed_tags'}}]);
	}
}

#------------------------------------------------------------------------------
sub flush($) {
#------------------------------------------------------------------------------
# Flush tags in object.

	my $self = shift;
	my $ouf = $self->{'output_handler'};
	if ($ouf) {
		print $ouf join("\n", @{$self->{'flush_code'}});
	} else {
		return join("\n", @{$self->{'flush_code'}});
	}
}

#------------------------------------------------------------------------------
sub open_tags($) {
#------------------------------------------------------------------------------
# Return array of opened tags.

	my $self = shift;
	return @{$self->{'printed_tags'}};
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
		push @{$self->{'tmp_code'}}, "($data->[1]";
		unshift @{$self->{'printed_tags'}}, $data->[1];

	# Comment.
	} elsif ($data->[0] eq 'c') {
		$self->_flush_tmp;
		shift @{$data};
		my $tmp_data = '';
		foreach my $d (@{$data}) {
			$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
		}
		push @{$self->{'flush_code'}}, 
			'_'.$self->_encode_newline($tmp_data);

	# Data.
	} elsif ($data->[0] eq 'd') {
		$self->_flush_tmp;
		shift @{$data};
		my $tmp_data = '';
		foreach my $d (@{$data}) {
			$tmp_data .= ref $d eq 'SCALAR' ? ${$d} : $d;
		}
		push @{$self->{'flush_code'}}, 
			'-'.$self->_encode_newline($tmp_data);

	# End of tag.
	} elsif ($data->[0] eq 'e') {
		$self->_flush_tmp;
		my $printed = shift @{$self->{'printed_tags'}};
		unless ($printed eq $data->[1]) {
			err "Ending bad tag: '$data->[1]' in block of ".
				"tag '$printed'.";
		}
		push @{$self->{'flush_code'}}, ")$data->[1]";

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		$self->_flush_tmp;
		shift @{$data};
		my $target = shift @{$data};
		my $tmp_data = '';
		while (@{$data}) {
			my $data = shift @{$data};
			$tmp_data .= " $data";
		}
		push @{$self->{'flush_code'}}, 
			"?$target ".$self->_encode_newline($tmp_data);

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

#------------------------------------------------------------------------------
sub _flush_tmp($) {
#------------------------------------------------------------------------------
# Flush tmp.

	my $self = shift;
	if ($self->{'tmp_code'}) {
		push @{$self->{'flush_code'}}, @{$self->{'tmp_code'}};
		$self->{'tmp_code'} = [];
	}
}

1;

=pod

=head1 NAME

 Tags2::Output::ESIS - ESIS class for line oriented output for 'Tags2'.

=head1 SYNOPSYS

 TODO

=head1 SESIS LINE CHARS

 _  - Comment data.
 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 -  - Normal data.

=head1 METHODS

=over 8

=item B<new()>

 TODO

=head2 PARAMETERS

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

=head1 REQUIREMENTS

 L<Error::Simple::Multiple>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
