#------------------------------------------------------------------------------
package Tags2::Output::LibXML;
#------------------------------------------------------------------------------
# $Id: LibXML.pm,v 1.9 2007-09-12 02:43:18 skim Exp $

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
	$self->{'output_handler'} = '';

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
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." unless exists $self->{$key};
                $self->{$key} = $val;
        }

	# Initialization.
	$self->_init;

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
	if ($ouf) {
		print $ouf $self->{'doc'}->toString(
			$self->{'set_indent'} ? 2 : 0);
	} else {
		return $self->{'doc'}->toString(
			$self->{'set_indent'} ? 2 : 0);
	}
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
	$self->_init;
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
		my $tmp = '';
		foreach my $d (@{$data}) {
			$tmp .= ref $d eq 'SCALAR' ? ${$d} 
				: $d;
		}
		my $comment_node = $self->{'doc'}->createComment($tmp);
		$self->{'printed_tags'}->[0]->addChild($comment_node);

	# Cdata.
	} elsif ($data->[0] eq 'cd') {
		my $tmp = '';
		foreach my $d (@{$data}) {
			$tmp .= ref $d eq 'SCALAR' ? ${$d} 
				: $d;
		}
		my $cdata_node = $self->{'doc'}->create($tmp);
		$self->{'printed_tags'}->[0]->addChild($cdata_node);

	# Data.
	} elsif ($data->[0] eq 'd') {
		my $tmp = '';
		shift @{$data};
		foreach my $d (@{$data}) {
			$tmp .= ref $d eq 'SCALAR' ? ${$d} 
				: $d;
		}
		my $data_node = $self->{'doc'}->createTextNode($tmp);
		$self->{'printed_tags'}->[0]->addChild($data_node);

	# End of tag.
	} elsif ($data->[0] eq 'e') {
		shift @{$self->{'printed_tags'}};

	# Instruction.
	} elsif ($data->[0] eq 'i') {
		shift @{$data};
		my $target = shift @{$data};
		my $tmp = '';
		while (@{$data}) {
			my $tmp_data = shift @{$data};
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

	# Raw data.
	} elsif ($data->[0] eq 'r') {
#		shift @{$data};
#		while (@{$data}) {
#			my $data = shift @{$data};
#			$self->{'flush_code'} .= $data;
#		}

	# Other.
	} else {
		err "Bad type of data." if $self->{'skip_bad_tags'};

	}
}

#------------------------------------------------------------------------------
sub _init($) {
#------------------------------------------------------------------------------
# Incialization.

	my $self = shift;

	# Printed tags.
	$self->{'printed_tags'} = [];

	# Root node.
	$self->{'doc'} = XML::LibXML::Document->new('1.1', 
		$self->{'encoding'});

	# First node = root node.
	$self->{'first'} = 0;
}

1;

=pod

=head1 NAME

 Tags2::Output::Raw - Raw printing 'Tags2' structure to tags code.

=head1 SYNOPSIS

 use Tags2::Output::Raw;
 my $t = Tags2::Output::Raw->new;
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

=head1 REQUIREMENTS

 L<Error::Simple::Multiple>
 L<XML::LibXML>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
