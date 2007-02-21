#------------------------------------------------------------------------------
package Tags2::Output::Indent;
#------------------------------------------------------------------------------
# $Id: Indent.pm,v 1.15 2007-02-21 00:14:57 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;
use Indent;
use Indent::Word;
use Indent::Block;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new($@) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Indent params.
	$self->{'next_indent'} = '  ';
	$self->{'line_size'} = 79;
	$self->{'linebreak'} = "\n";

	# Set output handler.
	$self->{'output_handler'} = *STDOUT;

	# No simple tags.
	$self->{'no_simple'} = [];

	# Preserved tags.
	$self->{'preserved'} = [];

	# Attribute delimeter.
	$self->{'attr_delimeter'} = '"';

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Indent object.
	$self->{'indent'} = Indent->new(
		'next_indent' => $self->{'next_indent'}
	);

	# Indent::Word object.
	$self->{'indent_word'} = Indent::Word->new(
		'line_size' => $self->{'line_size'},
		'next_indent' => '',
	);

	# Indent::Block object.
	$self->{'indent_block'} = Indent::Block->new(
		'line_size' => $self->{'line_size'},
		'next_indent' => $self->{'next_indent'},
		'strict' => 0,
	);

	# Flush code.
	$self->{'flush_code'} = '';

	# Tmp code.
	$self->{'tmp_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Non indent flag.
	$self->{'non_indent'} = 0;

	# xml:space value of actual tag.
	$self->{'xml_space'} = {};

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
	print $ouf $self->{'flush_code'};
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

	my ($self, @data) = @_;

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
	$self->{'flush_code'} = '';
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
			push @{$self->{'tmp_code'}}, ' ', $par, '=', 
				$self->{'attr_delimeter'}.$val.
				$self->{'attr_delimeter'};
		}

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_print_tag('>');
		}
		push @{$self->{'tmp_code'}}, "<$data->[1]";
		unshift @{$self->{'printed_tags'}}, $data->[1];

	# Comment.
	} elsif ($data->[0] eq 'c') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_print_tag('>');
		}
		shift @{$data};
		my @comment = ();
		push @comment, '<!--';
		foreach my $d (@{$data}) {
			push @comment, (ref $d eq 'SCALAR') ? ${$d} : $d;
		}
		push @comment, '-->';
		$self->{'flush_code'} .= "\n" if $self->{'flush_code'};
		$self->{'flush_code'} .= $self->{'indent_block'}->indent(
			\@comment,
			$self->{'indent'}->get,
		);

	# Data.
	} elsif ($data->[0] eq 'd') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_print_tag('>');
		}
		shift @{$data};
		my @tmp_data;
		foreach my $d (@{$data}) {
			push @tmp_data, (ref $d eq 'SCALAR') ? ${$d} : $d;
		}
		$self->{'flush_code'} .= "\n" if $self->{'flush_code'};
		$self->{'flush_code'} .= $self->{'indent_word'}->indent(
			join('', @tmp_data), $self->{'indent'}->get,
		);

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
				$self->_print_tag('/>');
			} else {
				$self->_print_end_tag($data->[1]);
			}

		# Tag cannot be simple.
		} else {
			$self->_print_tag('>');
			$self->_print_end_tag($data->[1]);
		}

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_print_tag('>');
		}
		shift @{$data};
		my $target = shift @{$data};
		$self->{'flush_code'} .= "\n" if $self->{'flush_code'};
		$self->{'flush_code'} .= $self->{'indent_block'}->indent([
			'<?'.$target, ' ', @{$data}, '?>',
			$self->{'indent'}->get,
		]);

	# Raw data.
	} elsif ($data->[0] eq 'r') {
		shift @{$data};
		while (@{$data}) {
			my $data = shift @{$data};
			$self->{'flush_code'} .= $data;
		}

	# CData.
	} elsif ($data->[0] eq 'cd') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_print_tag('>');
		}
		shift @{$data};
		my @cdata = ('<![CDATA[');
		foreach (@{$data}) {
			push @cdata, $_;
		}
		push @cdata, ']]>';
		$self->{'flush_code'} .= "\n" if $self->{'flush_code'};
		$self->{'flush_code'} .= $self->{'indent_block'}->indent(
			\@cdata, $self->{'indent'}->get,
		);

	# Other.
	} else {
		err "Bad type of data." unless $self->{'skip_bad_tags'};
	}
}

#------------------------------------------------------------------------------
sub _print_tag($$) {
#------------------------------------------------------------------------------
# Print indented tag from @{$self->{'tmp_code'}}.

	my ($self, $string) = @_;
	if ($string) {
		if ($string =~ /^\/>$/) {
			push @{$self->{'tmp_code'}}, ' ';
		}
		push @{$self->{'tmp_code'}}, $string;
	}
	$self->{'flush_code'} .= "\n" if $self->{'flush_code'};
	$self->{'flush_code'} .= $self->{'indent_block'}->indent(
		$self->{'tmp_code'}, $self->{'indent'}->get,
	);
	$self->{'tmp_code'} = [];
	if (! $self->{'non_indent'}) {
		$self->{'indent'}->add;
	}
}

#------------------------------------------------------------------------------
sub _print_end_tag($$) {
#------------------------------------------------------------------------------
# Print indented end of tag.

	my ($self, $string) = @_;
	if (! $self->{'non_indent'}) {
		$self->{'indent'}->remove;
	}
	$self->{'flush_code'} .= "\n" if $self->{'flush_code'};
	$self->{'flush_code'} .= $self->{'indent_block'}->indent(
		['</'.$string, '>'], $self->{'indent'}->get,
	);
}

1;

=pod

=head1 NAME

 Tags2::Output::Indent - Indent class for Tags2.

=head1 SYNOPSIS

TODO

=head1 METHODS

=over 8

=item B<new(%parameters)>

TODO

=head2 PARAMETERS

=over 8

TODO

=item B<output_handler>

 TODO

=item B<no-simple>

 TODO

=item B<attr_delimeter>

 TODO

=item B<preserved>

 TODO

=item B<skip_bad_tags>

 TODO

=item B<next_indent>

 TODO

=item B<output_separator>

 TODO

=item B<line_size>

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
 L<Indent>
 L<Indent::Word>
 L<Indent::Block>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
