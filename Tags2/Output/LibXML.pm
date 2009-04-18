#------------------------------------------------------------------------------
package Tags2::Output::LibXML;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Tags2::Output::Core);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Readonly;
use XML::LibXML;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};

# Version.
our $VERSION = 0.02;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# CDATA callback.
	$self->{'cdata_callback'} = undef;

	# Data callback.
	$self->{'data_callback'} = undef;

	# Document encoding.
	$self->{'encoding'} = 'UTF-8';

	# No simple tags.
	# TODO not implemented.
	$self->{'no_simple'} = [];

	# Set output handler.
	$self->{'output_handler'} = $EMPTY_STR;

	# Preserved tags.
	# TODO not implemented.
	$self->{'preserved'} = [];

	# Set indent.
	$self->{'set_indent'} = 0;

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# XML version.
	$self->{'xml_version'} = '1.1';

	# Process params.
	while (@params) {
		my $key = shift @params;
		my $val = shift @params;
		err "Bad parameter '$key'." if ! exists $self->{$key};
		$self->{$key} = $val;
	}

	# Initialization.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub flush {
#------------------------------------------------------------------------------
# Flush tags in object.

	my $self = shift;
	my $ouf = $self->{'output_handler'};
	if ($ouf) {
		print {$ouf} $self->{'doc'}->toString(
			$self->{'set_indent'} ? 2 : 0)
			|| err 'Cannot write to output handler.';;
		return;
	} else {
		return $self->{'doc'}->toString(
			$self->{'set_indent'} ? 2 : 0);
	}
}

#------------------------------------------------------------------------------
sub reset {
#------------------------------------------------------------------------------
# Resets internal variables.

	my $self = shift;

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Root node.
	$self->{'doc'} = XML::LibXML::Document->new(
		$self->{'xml_version'},
		$self->{'encoding'},
	);

	# First node = root node.
	$self->{'first'} = 0;

	return;
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _put_attribute {
#------------------------------------------------------------------------------
# Attributes.

	my ($self, $attr, $value) = @_;
	$self->{'printed_tags'}->[0]->setAttribute($attr, $value);
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $tag) = @_;
	my $begin_node = $self->{'doc'}->createElement($tag);
	if ($self->{'first'} == 0) {
		$self->{'doc'}->setDocumentElement($begin_node);
		$self->{'first'} = 1;
	} else {
		if (! $self->{'printed_tags'}->[0]) {
			err "Second root tag '$tag' is bad.";
		} else {
			$self->{'printed_tags'}->[0]->addChild($begin_node);
		}
	}
	unshift @{$self->{'printed_tags'}}, $begin_node;
	return;
}

#------------------------------------------------------------------------------
sub _put_cdata {
#------------------------------------------------------------------------------
# CData.

	my ($self, @cdata) = @_;
	$self->_process_callback(\@cdata, 'cdata_callback');
	my $cdata = join($EMPTY_STR, @cdata);
	my $cdata_node = $self->{'doc'}->createCDATASection($cdata);
	$self->{'printed_tags'}->[0]->addChild($cdata_node);
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, @comments) = @_;
	my $comment = join($EMPTY_STR, @comments);
	my $comment_node = $self->{'doc'}->createComment($comment);
	if (! defined $self->{'printed_tags'}->[0]) {
		$self->{'doc'}->appendChild($comment_node);
	} else {
		$self->{'printed_tags'}->[0]->addChild($comment_node);
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, @data) = @_;
	$self->_process_callback(\@data, 'data_callback');
	my $data = join($EMPTY_STR, @data);
	my $data_node = $self->{'doc'}->createTextNode($data);
	$self->{'printed_tags'}->[0]->addChild($data_node);
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $tag) = @_;
	shift @{$self->{'printed_tags'}};
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $target, $code) = @_;
	my $instruction_node = $self->{'doc'}->createProcessingInstruction(
		$target, $code,
	);
	if (! defined $self->{'printed_tags'}->[0]) {
		$self->{'doc'}->appendChild($instruction_node);
	} else {
		$self->{'printed_tags'}->[0]->addChild($instruction_node);
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_raw {
#------------------------------------------------------------------------------
# Raw data.

	my ($self, @raw_data) = @_;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Output::LibXML - Printing 'Tags2' structure by LibXML library.

=head1 SYNOPSIS

 use Tags2::Output::LibXML;
 my $t = Tags2::Output::LibXML->new;
 $t->put(['b', 'tag'], ['d', 'data']);
 $t->finalize;
 $t->flush;
 $t->reset;
 $t->put(['b', 'tag'], ['d', 'data']);
 my @open_tags = $t->open_tags;

=head1 DESCRIPTION

 This class is only for XML structures.

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=over 8

=item * B<cdata_callback>

 Subroutine for output processing of cdata.
 Input argument is reference to array.
 Default value is undef.
 Example is similar as 'data_callback'.

=item * B<data_callback>

 Subroutine for output processing of data, cdata and raw data.
 Input argument is reference to array.
 Default value is undef.

 Example:
 'data_callback' => sub {
         my $data_arr_ref = shift;
	 foreach my $data (@{$data_arr_ref}) {

	         # Some process.
	         $data =~ s/^\s*//ms;
	 }
 }

=item * B<encoding>

 Encoding for XML header.
 Default is 'UTF-8'.

=item * B<no_simple>

 TODO

=item * B<output_handler>

 Handler for print output strings.
 Default is *STDOUT.

=item * B<preserved>

 TODO

=item * B<set_indent>

 TODO
 Default is 0.

=item * B<skip_bad_tags>

 TODO

=item * B<xml_version>

 XML version for XML header.
 Default is "1.1".

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

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>,
L<XML::LibXML(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Core(3pm)>,
L<Tags2::Output::Debug(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::Indent2(3pm)>,
L<Tags2::Output::PYX(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::SESIS(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.02

=cut
