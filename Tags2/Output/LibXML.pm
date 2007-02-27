#------------------------------------------------------------------------------
package Tags2::Output::LibXML;
#------------------------------------------------------------------------------
# $Id: LibXML.pm,v 1.1 2007-02-27 17:28:47 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;
use XML::LibXML;

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

	# No simple tags.
	$self->{'no_simple'} = [];

	# Attribute delimeter.
	$self->{'attr_delimeter'} = '"';

	# Set indent.
	$self->{'set_indent'} = 0;

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

	# Flush code.
	$self->{'flush_code'} = '';

	# Tmp code.
	$self->{'tmp_code'} = [];

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Root node.
	$self->{'doc'} = XML::LibXML::Document->new('1.1', 'UTF-8');

	# First node = root node.
	$self->{'first'} = 0;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub finalize($) {
#------------------------------------------------------------------------------
# Finalize Tags output.

	my $self = shift;
	foreach (@{$self->{'printed_tags'}}) {
		$self->put(['e', $_]);
	}
}

#------------------------------------------------------------------------------
sub flush($) {
#------------------------------------------------------------------------------
# Flush tags in object.

	my $self = shift;
	my $ouf = $self->{'output_handler'};
	print $ouf $self->{'doc'}->toString;
}

#------------------------------------------------------------------------------
sub open_tags($) {
#------------------------------------------------------------------------------
# Return array of opened tags.

	my $self = shift;
	# TODO
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
		shift @{$data};
		while (@{$data}) {
			my $par = shift @{$data};
			my $val = shift @{$data};
			$self->{'printed_tags'}->[0]->setAttribute($par, $val);
		}

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		my $begin_node = $self->{'doc'}->createElement($data->[1]);
		if ($self->{'first'} == 0) {
			$self->{'doc'}->setDocumentElement($begin_node);
			$self->{'first'} = 1;
		} else {
			$self->{'printed_tags'}->[0]->addChild($begin_node);
		}
		unshift @{$self->{'printed_tags'}}, $begin_node;

	# Comment.
	} elsif ($data->[0] eq 'c') {
		my $comment_node = $self->{'doc'}->createComment($data->[1]);
		$self->{'printed_tags'}->[0]->addChild($comment_node);

	# Cdata.
	} elsif ($data->[0] eq 'cd') {
		my $cdata_node = $self->{'doc'}->create($data->[1]);
		$self->{'printed_tags'}->[0]->addChild($cdata_node);

	# Data.
	} elsif ($data->[0] eq 'd') {
		my $data_node = $self->{'doc'}->createTextNode($data->[1]);
		$self->{'printed_tags'}->[0]->addChild($data_node);

	# End of tag.
	} elsif ($data->[0] eq 'e') {
		shift @{$self->{'printed_tags'}};
		$self->{'printed_tags'}->[0] = shift @{$self->{'printed_tags'}};

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		my $instruction_node 
			= $self->{'doc'}->createProcessingInstruction(
			$data->[1], $data->[2]);
		if (! defined $self->{'printed_tags'}->[0]) {
			$self->{'doc'}->appendChild($instruction_node);
		} else {
			$self->{'printed_tags'}->[0]->addChild($instruction_node);
		}

	# Raw data.
	} elsif ($data->[0] eq 'r') {

	# Other.
	} else {
		err "Bad type of data.";
	}
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

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
