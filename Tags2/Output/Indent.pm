#------------------------------------------------------------------------------
package Tags2::Output::Indent;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Indent;
use Indent::Word;
use Indent::Block;
use Readonly;
use Tags2::Utils::Preserve;

# Constants.
Readonly::Scalar my $EMPTY => q{};
Readonly::Scalar my $LAST_INDEX => -1;
Readonly::Scalar my $LINE_SIZE => 79;
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.05;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Auto-flush.
	$self->{'auto_flush'} = 0;

	# Indent params.
	$self->{'next_indent'} = $SPACE x 2;
	$self->{'line_size'} = $LINE_SIZE;

	# Output handler.
	$self->{'output_handler'} = $EMPTY;

	# Output separator.
	$self->{'output_sep'} = "\n";

	# No simple tags.
	$self->{'no_simple'} = [];

	# Preserved tags.
	$self->{'preserved'} = [];

	# Attribute delimeter.
	$self->{'attr_delimeter'} = '"';

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# Callback to instruction.
	$self->{'instruction'} = $EMPTY;

	# Indent CDATA section.
	$self->{'cdata_indent'} = 0;

	# XML output.
	$self->{'xml'} = 0;

	# Process params.
	while (@params) {
		my $key = shift @params;
		my $val = shift @params;
		err "Bad parameter '$key'." if ! exists $self->{$key};
		$self->{$key} = $val;
	}

	# Check 'attr_delimeter'.
	if ($self->{'attr_delimeter'} ne '"'
		&& $self->{'attr_delimeter'} ne '\'') {

		err "Bad attribute delimeter '$self->{'attr_delimeter'}'.";
	}

	# Check auto-flush only with output handler.
	if ($self->{'auto_flush'} && $self->{'output_handler'} eq $EMPTY) {
		err '\'auto_flush\' parameter can\'t use without '.
			'\'output_handler\' parameter.';
	}

	# Reset.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub reset {
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
		'next_indent' => $EMPTY,
	);

	# Indent::Block object.
	$self->{'indent_block'} = Indent::Block->new(
		'line_size' => $self->{'line_size'},
		'next_indent' => $self->{'next_indent'},
		'strict' => 0,
	);

	# Flush code.
	$self->{'flush_code'} = $EMPTY;

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

	# Process flag.
	$self->{'process'} = 0;

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _flush_code {
#------------------------------------------------------------------------------
# Helper for flush data.

	my ($self, $code) = @_;
	$self->{'process'} = 1 if ! $self->{'process'};
	$self->{'flush_code'} .= $code;
	return;
}

#------------------------------------------------------------------------------
sub _newline {
#------------------------------------------------------------------------------
# Print newline if need.

	my $self = shift;

	# Null raw tag (normal tag processing).
	if ($self->{'raw_tag'}) {
		$self->{'raw_tag'} = 0;

	# Adding newline if flush_code.
	} else {
		my (undef, $pre_pre) = $self->{'preserve_obj'}->get;
		if ($self->{'process'} && $pre_pre == 0) {
			$self->_flush_code("\n");
		}
	}
	return;
}

#------------------------------------------------------------------------------
sub _print_tag {
#------------------------------------------------------------------------------
# Print indented tag from @{$self->{'tmp_code'}}.

	my ($self, $string) = @_;
	if ($string) {
		if ($string =~ /^\/>$/ms) {
			push @{$self->{'tmp_code'}}, $SPACE;
		}
		push @{$self->{'tmp_code'}}, $string;
	}

	# Flush comment code before tag.
	# TODO Optimalization.
	if ($self->{'comment_flag'} == 0
		&& scalar @{$self->{'tmp_comment_code'}}) {

		# Comment.
		foreach (@{$self->{'tmp_comment_code'}}) {
			$self->_newline;
			$self->_flush_code($self->{'indent_block'}->indent(
				$_, $self->{'indent'}->get,
			));
		}

		my $pre = $self->{'preserve_obj'}->get;
		my $act_indent;
		if (! $self->{'non_indent'} && ! $pre) {
			$act_indent = $self->{'indent'}->get;
		}
		$self->_newline;

		# TODO Pravdepodobna chyba jako dole.
		$self->_flush_code($self->{'indent_block'}->indent(
			$self->{'tmp_code'}, $act_indent, $pre ? 1 : 0
		));

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

		# TODO Proc tohle nejde volat primo?
		my $tmp = $self->{'indent_block'}->indent(
			$self->{'tmp_code'}, $act_indent, $pre ? 1 : 0
		);
		$self->_flush_code($tmp);

		$self->{'tmp_code'} = [];
		if (! $self->{'non_indent'} && ! $pre) {
			$self->{'indent'}->add;
		}
		$self->{'preserve_obj'}->begin($self->{'printed_tags'}->[0]);

		foreach (@{$self->{'tmp_comment_code'}}) {
			$self->_newline;
			$self->_flush_code($self->{'indent_block'}->indent(
				$_, $self->{'indent'}->get,
			));
		}
	}
	$self->{'tmp_comment_code'} = [];
	return;
}

#------------------------------------------------------------------------------
sub _print_end_tag {
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
	$self->_flush_code($self->{'indent_block'}->indent(
		['</'.$string, '>'], $act_indent, $pre ? 1 : 0
	));
	return;
}

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, @pairs) = @_;
	if (! scalar @{$self->{'tmp_code'}}) {
		err 'Bad tag type \'a\'.';
	}

	# TODO Check to pairs.

	while (@pairs) {
		my $par = shift @pairs;
		my $val = shift @pairs;
		push @{$self->{'tmp_code'}}, $SPACE, $par, '=',
			$self->{'attr_delimeter'}.$val.
			$self->{'attr_delimeter'};
		$self->{'comment_flag'} = 0;
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $tag) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_print_tag('>');
	}

	# XML check for uppercase names.
	if ($self->{'xml'} && $tag ne lc($tag)) {
		err 'In XML must be lowercase tag name.';
	}

	push @{$self->{'tmp_code'}}, "<$tag";
	unshift @{$self->{'printed_tags'}}, $tag;
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_print_tag('>');
	}
	unshift @cdata, '<![CDATA[';
	if (join($EMPTY, @cdata) =~ /]]>$/ms) {
		err 'Bad CDATA section.' 
	}
	push @cdata, ']]>';
	$self->_newline;
	$self->{'preserve_obj'}->save_previous;

	# TODO Proc tohle nejde volat primo?
	my $tmp = $self->{'indent_block'}->indent(
		\@cdata, $self->{'indent'}->get,
		$self->{'cdata_indent'} == 1 ? 0 : 1,
	);
	$self->_flush_code($tmp);
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;
	unshift @comments, '<!--';
	if (substr($comments[$LAST_INDEX], $LAST_INDEX) eq '-') {
		push @comments, ' -->';
	} else {
		push @comments, '-->';
	}

	# Process comment.
	if (scalar @{$self->{'tmp_code'}}) {
		push @{$self->{'tmp_comment_code'}}, \@comments;

		# Flag, that means comment is last.
		$self->{'comment_flag'} = 1;
	} else {
		$self->_newline;
		$self->_flush_code($self->{'indent_block'}->indent(
			\@comments,
			$self->{'indent'}->get,
		));
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @data) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_print_tag('>');
	}
	$self->_newline;
	$self->{'preserve_obj'}->save_previous;
	my $pre = $self->{'preserve_obj'}->get;
	$self->_flush_code($self->{'indent_word'}->indent(
		join($EMPTY, @data),
		$pre ? $EMPTY : $self->{'indent'}->get,
		$pre ? 1 : 0
	));
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	my $printed = shift @{$self->{'printed_tags'}};
	if ($self->{'xml'} && $printed ne $tag) {
		err "Ending bad tag: '$tag' in block of tag '$printed'.";
	}

	# Tag can be simple.
	if ($self->{'xml'} && (! scalar @{$self->{'no_simple'}}
		|| none { $_ eq $tag} @{$self->{'no_simple'}})) {

		my $pre = $self->{'preserve_obj'}->end($tag);
		if (scalar @{$self->{'tmp_code'}}) {
			if (scalar @{$self->{'tmp_comment_code'}}
				&& $self->{'comment_flag'} == 1) {

				$self->_print_tag('>');
# XXX				$self->{'preserve_obj'}->end($tag);
				$self->_print_end_tag($tag);
			} else {
				$self->_print_tag('/>');
				if (! $self->{'non_indent'} && ! $pre) {
					$self->{'indent'}->remove;
				}
			}
		} else {
			$self->_print_end_tag($tag);
		}

	# Tag cannot be simple.
	} else {
		if (scalar @{$self->{'tmp_code'}}) {
			unshift @{$self->{'printed_tags'}}, $tag;
			$self->_print_tag('>');
			shift @{$self->{'printed_tags'}};
# XXX				$self->_newline;
		}
		$self->{'preserve_obj'}->end($tag);
		$self->_print_end_tag($tag);
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $target, $code) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_print_tag('>');
	}
	if (ref $self->{'instruction'} eq 'CODE') {
		$self->{'instruction'}->($self, $target, $code);
	} else {
		$self->_newline;
		$self->{'preserve_obj'}->save_previous;
		$self->_flush_code($self->{'indent_block'}
			->indent([
			'<?'.$target, $SPACE, $code, '?>',
			$self->{'indent'}->get,
		]));
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, @raw_data) = @_;
	if (scalar @{$self->{'tmp_code'}}) {
		$self->_print_tag('>');
	}
	foreach my $data (@raw_data) {
		$self->_flush_code($data);
	}
	$self->{'raw_tag'} = 1;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::Indent - Indent class for Tags2.

=head1 SYNOPSIS

 use Tags2::Output::Indent(%params);
 my $t = Tags2::Output::Indent->new;
 $t->put(['b', 'tag']);
 $t->finalize;
 $t->flush;
 $t->reset;
 $t->put(['b', 'tag']);
 my @open_tags = $t->open_tags;

=head1 METHODS

=over 8

=item B<new(%params)>

 Constructor

=over 8

=item * B<attr_delimeter>

 String, that defines attribute delimeter.
 Default is '"'.
 Possible is '"' or "'".

 Example:
 Prints <tag attr='val' /> instead default <tag attr="val" />

 my $t = Tags2::Output::Indent->new(
   'attr_delimeter' => "'",
 );
 $t->put(['b', 'tag'], ['a', 'attr', 'val'], ['e', 'tag']);
 $t->flush;

=item * B<auto_flush>

 Auto flush flag.
 Default is 0.

=item * B<cdata_indent>

 Flag, that means indent CDATA section.
 Default value is no-indent (0).

=item * B<line_size>

 TODO
 Default value is 79.

=item * B<next_indent>

 TODO
 Default value is "  ".

=item * B<no_simple>

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

=item * B<output_handler>

 Handler for print output strings.
 Default is *STDOUT.

=item * B<output_separator>

 TODO
 Default value is newline (\n).

=item * B<preserved>

 TODO
 Default is reference to blank array.

=item * B<skip_bad_tags>

 TODO
 Default is 0.

=back

=item B<finalize()>

 Finalize Tags output.
 Automaticly puts end of all opened tags.

=item B<flush($reset_flag)>

 Flush tags in object.
 If defined 'output_handler' flush to its.
 Or return code.
 If enabled $reset_flag, then resets internal variables via reset method.

=item B<open_tags()>

 Return array of opened tags.

=item B<put(@data)>

 Put tags code in tags2 format.

=item B<reset()>

 Resets internal variables.

=back

=head1 ERRORS

 'auto_flush' parameter can't use without 'output_handler' parameter.
 Bad attribute delimeter '%s'.
 Bad CDATA section.
 Bad data.
 Bad parameter '%s'.
 Bad tag type 'a'.
 Bad type of data.
 Ending bad tag: '%s' in block of tag '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Output::Indent;

 # Object.
 my $tags = Tags2::Output::Indent->new;

 # Put data.
 $tags->put(
         ['b', 'text'],
	 ['d', 'data'],
	 ['e', 'text'],
 );

 # Print.
 print $tags->flush."\n";

 # Output:
 # <text>
 #   data
 # </text>

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Indent(3pm)>,
L<Indent::Word(3pm)>,
L<Indent::Block(3pm)>,
L<Tags2::Utils::Preserve(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::PYX(3pm)>,
L<Tags2::Output::SESIS(3pm)>.

=head1 AUTHOR

 Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

 BSD license.

=head1 VERSION

 0.05

=cut
