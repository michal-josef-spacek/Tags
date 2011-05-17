package Tags2::Output::LibXML;

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

# Flush tags in object.
sub flush {
	my $self = shift;
	my $ouf = $self->{'output_handler'};
	if ($ouf) {
		no warnings;
		print {$ouf} $self->{'doc'}->toString(
			$self->{'set_indent'} ? 2 : 0)
			or err 'Cannot write to output handler.';
		return;
	} else {
		return $self->{'doc'}->toString(
			$self->{'set_indent'} ? 2 : 0);
	}
}

# Resets internal variables.
sub reset {
	my $self = shift;

	# Root node.
	$self->{'doc'} = XML::LibXML::Document->new(
		$self->{'xml_version'},
		$self->{'encoding'},
	);

	# First node = root node.
	$self->{'first'} = 0;

	# Printed tags.
	$self->{'printed_tags'} = [];

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

	return;
}

# Default parameters.
sub _default_parameters {
	my $self = shift;

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
	$self->{'output_handler'} = undef;

	# Preserved tags.
	# TODO not implemented.
	$self->{'preserved'} = [];

	# Set indent.
	$self->{'set_indent'} = 0;

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

	# XML version.
	$self->{'xml_version'} = '1.1';

	return;
}

# Attributes.
sub _put_attribute {
	my ($self, $attr, $value) = @_;
	$self->{'printed_tags'}->[0]->setAttribute($attr, $value);
	return;
}

# Begin of tag.
sub _put_begin_of_tag {
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

# CData.
sub _put_cdata {
	my ($self, @cdata) = @_;
	$self->_process_callback(\@cdata, 'cdata_callback');
	my $cdata = join($EMPTY_STR, @cdata);
	my $cdata_node = $self->{'doc'}->createCDATASection($cdata);
	$self->{'printed_tags'}->[0]->addChild($cdata_node);
	return;
}

# Comment.
sub _put_comment {
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

# Data.
sub _put_data {
	my ($self, @data) = @_;
	$self->_process_callback(\@data, 'data_callback');
	my $data = join($EMPTY_STR, @data);
	my $data_node = $self->{'doc'}->createTextNode($data);
	$self->{'printed_tags'}->[0]->addChild($data_node);
	return;
}

# End of tag.
sub _put_end_of_tag {
	my ($self, $tag) = @_;
	shift @{$self->{'printed_tags'}};
	return;
}

# Instruction.
sub _put_instruction {
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

# Raw data.
sub _put_raw {
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
 my $tags2 = Tags2::Output::LibXML->new(%parameters);
 $tags2->put(
	['b', 'tag'],
	['d', 'data'],
 );
 my @open_tags = $tags2->open_tags;
 $tags2->finalize;
 $tags2->flush;
 $tags2->reset;

=head1 DESCRIPTION

 This class is only for XML structures.

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<cdata_callback>

 Subroutine for output processing of cdata.
 Input argument is reference to array.
 Default value is undef.
 Example is similar as 'data_callback'.

=item * C<data_callback>

 Subroutine for output processing of data, cdata and raw data.
 Input argument is reference to array.
 Default value is undef.

 Example:
 'data_callback' => sub {
         my $data_ar = shift;
	 foreach my $data (@{$data_ar}) {

	         # Some process.
	         $data =~ s/^\s*//ms;
	 }
 }

=item * C<encoding>

 Encoding for XML header.
 Default is 'UTF-8'.

=item * C<no_simple>

 TODO

=item * C<output_handler>

 Handler for print output strings.
 Must be a GLOB.
 Default is undef.

=item * C<preserved>

 TODO

=item * C<set_indent>

 TODO
 Default is 0.

=item * C<skip_bad_tags>

 TODO

=item * C<xml_version>

 XML version for XML header.
 Default is "1.1".

=back

=item C<finalize()>

 TODO

=item C<flush()>

 TODO

=item C<open_tags()>

 TODO

=item C<put()>

 TODO

=item C<reset()>

 TODO

=back

=head1 ERRORS

 TODO

=head1 EXAMPLE

 TODO

=head1 DEPENDENCIES

L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>,
L<XML::LibXML(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Core(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::Indent2(3pm)>,
L<Tags2::Output::PYX(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::SESIS(3pm)>,
L<Tags2::Utils(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.02

=cut
