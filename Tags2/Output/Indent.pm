#------------------------------------------------------------------------------
package Tags2::Output::Indent;
#------------------------------------------------------------------------------
# $Id: Indent.pm,v 1.30 2007-09-20 21:21:13 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;
use Indent;
use Indent::Word;
use Indent::Block;
use Tags2::Utils::Preserve;

# Version.
our $VERSION = 0.04;

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
	$self->{'output_handler'} = '';

	# No simple tags.
	$self->{'no_simple'} = [];

	# Preserved tags.
	$self->{'preserved'} = [];

	# Attribute delimeter.
	$self->{'attr_delimeter'} = '"';

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# Callback to instruction.
	$self->{'instruction'} = '';

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." if ! exists $self->{$key};
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

	# Comment flag.
	$self->{'comment_flag'} = 0;

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
	$self->{'tmp_comment_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Non indent flag.
	$self->{'non_indent'} = 0;

	# Flag, that means raw tag.
	$self->{'raw_tag'} = 0;

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
			push @{$self->{'tmp_code'}}, ' ', $par, '=', 
				$self->{'attr_delimeter'}.$val.
				$self->{'attr_delimeter'};
			$self->{'comment_flag'} = 0;
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

		# Comment data.
		shift @{$data};
		my @comment = ();
		push @comment, '<!--';
		foreach my $d (@{$data}) {
			push @comment, (ref $d eq 'SCALAR') ? ${$d} : $d;
		}
		if (substr($comment[-1], -1) eq '-') {
			push @comment, ' -->';
		} else {
			push @comment, '-->';
		}

		# Process comment.
		if ($#{$self->{'tmp_code'}} > -1) {
			push @{$self->{'tmp_comment_code'}}, \@comment;

			# Flag, that means comment is last.
			$self->{'comment_flag'} = 1;
		} else {
			$self->_newline;
			$self->{'flush_code'} .= $self->{'indent_block'}->indent(
				\@comment,
				$self->{'indent'}->get,
			);
		}

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
		$self->_newline;
		$self->{'preserve_obj'}->save_previous;
		my $pre = $self->{'preserve_obj'}->get;
		$self->{'flush_code'} .= $self->{'indent_word'}->indent(
			join('', @tmp_data), 
			$pre ? '' : $self->{'indent'}->get,
			$pre ? 1 : 0
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
			my $pre = $self->{'preserve_obj'}->end($data->[1]);
			if ($#{$self->{'tmp_code'}} > -1) {
				if ($#{$self->{'tmp_comment_code'}} > -1
					&& $self->{'comment_flag'} == 1) {

					$self->_print_tag('>');
					$self->_newline;
					$self->{'flush_code'} 
						.= "</$data->[1]>";
				} else {
					$self->_print_tag('/>');
				}
				if (! $self->{'non_indent'} && ! $pre) {
					$self->{'indent'}->remove;
				}
			} else {
				$self->_print_end_tag($data->[1]);
			}

		# Tag cannot be simple.
		} else {
			if ($#{$self->{'tmp_code'}} > -1) {
				unshift @{$self->{'printed_tags'}}, 
					$data->[1];
				$self->_print_tag('>');
				shift @{$self->{'printed_tags'}};
				$self->_newline;
			}
			$self->{'preserve_obj'}->end($data->[1]);
			$self->_print_end_tag($data->[1]);
		}

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		if ($#{$self->{'tmp_code'}} > -1) {
			$self->_print_tag('>');
		}
		shift @{$data};
		my $target = shift @{$data};
		if (ref $self->{'instruction'} eq 'CODE') {
			$self->{'instruction'}->($self, $target, @{$data});
		} else {
			$self->_newline;
			$self->{'preserve_obj'}->save_previous;
			$self->{'flush_code'} .= $self->{'indent_block'}
				->indent([
				'<?'.$target, ' ', @{$data}, '?>',
				$self->{'indent'}->get,
			]);
		}

	# Raw data.
	} elsif ($data->[0] eq 'r') {
		shift @{$data};
		while (@{$data}) {
			my $data = shift @{$data};
			$self->{'flush_code'} .= $data;
		}
		$self->{'raw_tag'} = 1;

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
		$self->_newline;
		$self->{'preserve_obj'}->save_previous;
		# TODO Ted je zapnute non-indent.
		# Tady bych se mel kouknout, jak se cdata sekce vubec chova.
		$self->{'flush_code'} .= $self->{'indent_block'}->indent(
			\@cdata, $self->{'indent'}->get, 1,
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

	# TODO Optimalization.
	my ($self, $string) = @_;
	if ($string) {
		if ($string =~ /^\/>$/) {
			push @{$self->{'tmp_code'}}, ' ';
		}
		push @{$self->{'tmp_code'}}, $string;
	}
	# Flush comment code before tag.
	if ($self->{'comment_flag'} == 0 
		&& $#{$self->{'tmp_comment_code'}} > -1) {

		foreach (@{$self->{'tmp_comment_code'}}) {
			$self->_newline;
			$self->{'flush_code'} .= $self->{'indent_block'}->indent(
				$_, $self->{'indent'}->get,
			);
		}

		my $pre = $self->{'preserve_obj'}->get;
		my $act_indent;
		if (! $self->{'non_indent'} && ! $pre) {
			$act_indent = $self->{'indent'}->get;
		}
		$self->_newline;
		$self->{'flush_code'} .= $self->{'indent_block'}->indent(
			$self->{'tmp_code'}, $act_indent, $pre ? 1 : 0
		);
		$self->{'tmp_code'} = [];
		if (! $self->{'non_indent'} && ! $pre) {
			$self->{'indent'}->add;
		}
		$self->{'preserve_obj'}->begin($self->{'printed_tags'}->[0]);
	} else {
		my $pre = $self->{'preserve_obj'}->get;
		my $act_indent;
		if (! $self->{'non_indent'} && ! $pre) {
			$act_indent = $self->{'indent'}->get;
		}
		$self->_newline;
		$self->{'flush_code'} .= $self->{'indent_block'}->indent(
			$self->{'tmp_code'}, $act_indent, $pre ? 1 : 0
		);
		$self->{'tmp_code'} = [];
		if (! $self->{'non_indent'} && ! $pre) {
			$self->{'indent'}->add;
		}
		$self->{'preserve_obj'}->begin($self->{'printed_tags'}->[0]);

		foreach (@{$self->{'tmp_comment_code'}}) {
			$self->_newline;
			$self->{'flush_code'} .= $self->{'indent_block'}->indent(
				$_, $self->{'indent'}->get,
			);
		}
	}
}

#------------------------------------------------------------------------------
sub _print_end_tag($$) {
#------------------------------------------------------------------------------
# Print indented end of tag.

	my ($self, $string) = @_;
	my $act_indent;
	my ($pre, $pre_pre) = $self->{'preserve_obj'}->get;
	if (! $self->{'non_indent'} && ! $pre) {
		$self->{'indent'}->remove;
		if (! $pre_pre) {
			$act_indent = $self->{'indent'}->get;
		}
	}
	$self->_newline;
	$self->{'flush_code'} .= $self->{'indent_block'}->indent(
		['</'.$string, '>'], $act_indent, $pre ? 1 : 0
	);
}

#------------------------------------------------------------------------------
sub _newline($) {
#------------------------------------------------------------------------------
# Print newline if need.

	my $self = shift;

	# Null raw tag (normal tag processing).
	if ($self->{'raw_tag'}) {
		$self->{'raw_tag'} = 0;

	# Adding newline if flush_code.
	} else {
		my (undef, $pre_pre) = $self->{'preserve_obj'}->get;
		if ($self->{'flush_code'} && $pre_pre == 0) {
			$self->{'flush_code'} .= "\n";
		}
	}
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

L<Error::Simple::Multiple>,
L<Indent>,
L<Indent::Word>,
L<Indent::Block>,
L<Tags2::Utils::Preserve>

=head1 SEE ALSO

L<Tags2::Output::Raw>,
L<Tags2::Output::LibXML>,
L<Tags2::Output::ESIS>,
L<Tags2::Output::PYX>,
L<Tags2::Output::SESIS>,
TODO

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.03

=cut
