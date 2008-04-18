#------------------------------------------------------------------------------
package Tags2::Output::Raw;
#------------------------------------------------------------------------------
# $Id: Raw.pm,v 1.30 2008-04-18 14:49:26 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;
use Tags2::Utils::Preserve;

# Version.
our $VERSION = 0.04;

#------------------------------------------------------------------------------
sub new($@) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Attribute delimeter.
	$self->{'attr_delimeter'} = '"';

	# No simple tags.
	$self->{'no_simple'} = [];

	# Set output handler.
	$self->{'output_handler'} = '';

	# Preserved tags.
	$self->{'preserved'} = [];

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." unless exists $self->{$key};
                $self->{$key} = $val;
        }

	# Check 'attr_delimeter'.
	if ($self->{'attr_delimeter'} ne '"' 
		&& $self->{'attr_delimeter'} ne "'") {

		err "Bad attribute delimeter '$self->{'attr_delimeter'}'.";
	}

	# Reset.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub finalize($) {
#------------------------------------------------------------------------------
# Finalize Tags output.

	my $self = shift;
	while (@{$self->{'printed_tags'}}) {
		$self->put(['e', $self->{'printed_tags'}->[0]]);
	}
}

#------------------------------------------------------------------------------
sub flush($) {
#------------------------------------------------------------------------------
# Flush tags in object.

	my $self = shift;
	my $ouf = $self->{'output_handler'};
	if ($ouf) {
		print $ouf $self->{'flush_code'};
	} else {
		return $self->{'flush_code'};
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

	# Comment flag.
	$self->{'comment_flag'} = 0;

	# Flush code.
	$self->{'flush_code'} = '';

	# Tmp code.
	$self->{'tmp_code'} = [];
	$self->{'tmp_comment_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Preserved object.
	$self->{'preserve_obj'} = Tags2::Utils::Preserve->new(
		'preserved' => $self->{'preserved'},
	);
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
		unless ($#{$self->{'tmp_code'}} > -1) {
			err "Bad tag type 'a'.";
		}
		shift @{$data};
		while (@{$data}) {
			my $par = shift @{$data};
			my $val = shift @{$data};
			push @{$self->{'tmp_code'}}, ' ', $par.'='.
				$self->{'attr_delimeter'}.$val.
				$self->{'attr_delimeter'};
			$self->{'comment_flag'} = 0;
		}

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_flush_tmp('>');
		}
		push @{$self->{'tmp_code'}}, "<$data->[1]";
		unshift @{$self->{'printed_tags'}}, $data->[1];
		$self->{'preserve_obj'}->begin($data->[1]);

	# Comment.
	} elsif ($data->[0] eq 'c') {

		# Comment string.
		shift @{$data};
		my $comment_string = '<!--';
		foreach my $d (@{$data}) {
			$comment_string .= ref $d eq 'SCALAR' ? ${$d} 
				: $d;
		}
		if (substr($comment_string, -1) eq '-') {
			$comment_string .= ' ';
		}
		$comment_string .= '-->';

		# Process comment.
		if ($#{$self->{'tmp_code'}} > -1) {
			push @{$self->{'tmp_comment_code'}}, $comment_string;

			# Flag, that means comment is last.
			$self->{'comment_flag'} = 1;
		} else {
			$self->{'flush_code'} .= $comment_string;
		}

	# Cdata.
	} elsif ($data->[0] eq 'cd') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_flush_tmp('>');
		}
		shift @{$data};
		$self->{'flush_code'} .= '<![CDATA[';
		foreach my $d (@{$data}) {
			$self->{'flush_code'} .= ref $d eq 'SCALAR' ? ${$d}
				: $d;
		}
		$self->{'flush_code'} .= ']]>';

	# Data.
	} elsif ($data->[0] eq 'd') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_flush_tmp('>');
		}
		shift @{$data};
		foreach my $d (@{$data}) {
			$self->{'flush_code'} .= ref $d eq 'SCALAR' ? ${$d} 
				: $d;
		}

	# End of tag.
	} elsif ($data->[0] eq 'e') {
		my $printed = shift @{$self->{'printed_tags'}};
		unless ($printed eq $data->[1]) {
			err "Ending bad tag: '$data->[1]' in block of ".
				"tag '$printed'.";
		}

		# Tag can be simple.
		if (! grep { $_ eq $data->[1] } @{$self->{'no_simple'}}) {
			if ($#{$self->{'tmp_code'}} > -1) {
				if ($#{$self->{'tmp_comment_code'}} > -1
					&& $self->{'comment_flag'} == 1) {

					$self->_flush_tmp('>');
					$self->{'flush_code'} 
						.= "</$data->[1]>";
				} else {
					$self->_flush_tmp(' />');
				}
			} else {
				$self->{'flush_code'} .= "</$data->[1]>";
			}

		# Tag cannot be simple.
		} else {
			if ($#{$self->{'tmp_code'}} > -1) {
				$self->_flush_tmp('>');
			}
			$self->{'flush_code'} .= "</$data->[1]>";
		}
		$self->{'preserve_obj'}->end($data->[1]);

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_flush_tmp('>');
		}
		shift @{$data};
		$self->{'flush_code'} .= '<?';
		my $target = shift @{$data};
		$self->{'flush_code'} .= $target;
		while (@{$data}) {
			my $data = shift @{$data};
			$self->{'flush_code'} .= " $data";
		}
		$self->{'flush_code'} .= '?>';

	# Raw data.
	} elsif ($data->[0] eq 'r') {
		shift @{$data};
		while (@{$data}) {
			my $data = shift @{$data};
			$self->{'flush_code'} .= $data;
		}

	# Other.
	} else {
		err "Bad type of data." if $self->{'skip_bad_tags'};
	}
}

#------------------------------------------------------------------------------
sub _flush_tmp($$) {
#------------------------------------------------------------------------------
# Flush $self->{'tmp_code'}.

	my ($self, $string) = @_;

	# Get tmp_code.
	push @{$self->{'tmp_code'}}, $string if $string;
	my ($pre, $pre_pre) = $self->{'preserve_obj'}->get;
	if ($pre && ! $pre_pre) {
		push @{$self->{'tmp_code'}}, "\n";
	}

	# Flush comment code before tag.
	if ($self->{'comment_flag'} == 0 
		&& $#{$self->{'tmp_comment_code'}} > -1) {

		$self->{'flush_code'} .= join('',
			@{$self->{'tmp_comment_code'}}, 
			@{$self->{'tmp_code'}});

	# After tag.
	} else {
		$self->{'flush_code'} .= join('',
			@{$self->{'tmp_code'}},
			@{$self->{'tmp_comment_code'}});
	}

	# Resets tmp_codes.
	$self->{'tmp_code'} = [];
	$self->{'tmp_comment_code'} = [];
}

1;

=pod

=head1 NAME

 Tags2::Output::Raw - Raw printing 'Tags2' structure to tags code.

=head1 SYNOPSIS

 use Tags2::Output::Raw;
 my $t = Tags2::Output::Raw->new;
 $t->put(['b', 'tag']);
 $t->finalize;
 $t->flush;
 $t->reset;
 $t->put(['b', 'tag']);
 my @open_tags = $t->open_tags;

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=head1 PARAMETERS

=over 8

=item B<output_handler>

 Handler for print output strings.
 Default is *STDOUT.

=item B<no-simple>

 Reference to array of tags, that can't by simple.
 Default is [].

 Example:
 That's normal in html pages, web browsers has problem with <script /> tag.
 Prints <script></script> instead <script />.

 my $t = Tags2::Output::Raw->new(
   'no_simple' => ['script'] 
 );
 $t->put(['b', 'script'], ['e', 'script']);
 $t->flush;

=item B<preserved>

 TODO

=item B<attr_delimeter>

 String, that defines attribute delimeter 
 Default is '"'.
 Possible is '"' or "'".

 Example:
 Prints <tag attr='val' /> instead default <tag attr="val" />

 my $t = Tags2::Output::Raw->new(
   'attr_delimeter' => "'",
 );
 $t->put(['b', 'tag'], ['a', 'attr', 'val'], ['e', 'tag']);
 $t->flush;

=item B<skip_bad_tags>

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

=head1 REQUIREMENTS

L<Error::Simple::Multiple>,
L<Tags2::Utils::Preserve>

=head1 SEE ALSO

L<Tags2::Output::ESIS>,
L<Tags2::Output::Indent>,
L<Tags2::Output::LibXML>,
L<Tags2::Output::PYX>,
L<Tags2::Output::SESIS>,
TODO

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.04

=cut
