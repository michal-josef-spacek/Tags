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
Readonly::Scalar my $EMPTY => q{};

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Set output handler.
	$self->{'output_handler'} = $EMPTY;

	# Set indent.
	$self->{'set_indent'} = 0;

	# Document encoding.
	$self->{'encoding'} = 'UTF-8';

	# Preserved tags.
	# TODO not implemented.
	$self->{'preserved'} = [];

	# No simple tags.
	# TODO not implemented.
	$self->{'no_simple'} = [];

	# Skip bad tags.
	$self->{'skip_bad_tags'} = 0;

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
			$self->{'set_indent'} ? 2 : 0);
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
	$self->{'doc'} = XML::LibXML::Document->new('1.1',
		$self->{'encoding'});

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

	my ($self, $data_ref) = @_;
	shift @{$data_ref};
	while (@{$data_ref}) {
		my $par = shift @{$data_ref};
		my $val = shift @{$data_ref};
		$self->{'printed_tags'}->[0]->setAttribute($par, $val);
	}
	return;
}

#------------------------------------------------------------------------------
sub _put_begin_of_tag {
#------------------------------------------------------------------------------
# Begin of tag.

	my ($self, $data_ref) = @_;
	my $begin_node = $self->{'doc'}->createElement($data_ref->[1]);
	if ($self->{'first'} == 0) {
		$self->{'doc'}->setDocumentElement($begin_node);
		$self->{'first'} = 1;
	} else {
		if (! $self->{'printed_tags'}->[0]) {
			err "Second root tag '$data_ref->[1]' is bad.";
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

	my ($self, $data_ref) = @_;
	my $tmp = $EMPTY;
	foreach my $d (@{$data_ref}) {
		$tmp .= ref $d eq 'SCALAR' ? ${$d} : $d;
	}
	my $cdata_node = $self->{'doc'}->create($tmp);
	$self->{'printed_tags'}->[0]->addChild($cdata_node);
	return;
}

#------------------------------------------------------------------------------
sub _put_comment {
#------------------------------------------------------------------------------
# Comment.

	my ($self, $data_ref) = @_;
	my $tmp = $EMPTY;
	foreach my $d (@{$data_ref}) {
		$tmp .= ref $d eq 'SCALAR' ? ${$d} : $d;
	}
	my $comment_node = $self->{'doc'}->createComment($tmp);
	$self->{'printed_tags'}->[0]->addChild($comment_node);
	return;
}

#------------------------------------------------------------------------------
sub _put_data {
#------------------------------------------------------------------------------
# Data.

	my ($self, $data_ref) = @_;
	my $tmp = $EMPTY;
	shift @{$data_ref};
	foreach my $d (@{$data_ref}) {
		$tmp .= ref $d eq 'SCALAR' ? ${$d} : $d;
	}
	my $data_node = $self->{'doc'}->createTextNode($tmp);
	$self->{'printed_tags'}->[0]->addChild($data_node);
	return;
}

#------------------------------------------------------------------------------
sub _put_end_of_tag {
#------------------------------------------------------------------------------
# End of tag.

	my ($self, $data_ref) = @_;
	shift @{$self->{'printed_tags'}};
	return;
}

#------------------------------------------------------------------------------
sub _put_instruction {
#------------------------------------------------------------------------------
# Instruction.

	my ($self, $data_ref) = @_;
	shift @{$data_ref};
	my $target = shift @{$data_ref};
	my $tmp = $EMPTY;
	while (@{$data_ref}) {
		my $tmp_data = shift @{$data_ref};
		$tmp .= " $tmp_data";
	}
	my $instruction_node
		= $self->{'doc'}->createProcessingInstruction(
		$target, $tmp);
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

	my ($self, $data_ref) = @_;
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

=head1 PARAMETERS

=over 8

=item B<output_handler>

 Handler for print output strings.
 Default is *STDOUT.

=item B<set_indent>

 TODO

=item B<encoding>

 TODO

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

 0.01

=cut
