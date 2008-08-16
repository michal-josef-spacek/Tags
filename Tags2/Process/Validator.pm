#------------------------------------------------------------------------------
package Tags2::Process::Validator;
#------------------------------------------------------------------------------
# $Id: Validator.pm,v 1.7 2008-08-16 19:36:02 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;
use XML::DTDParser qw(ParseDTDFile);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new($@) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# DTD structure.
	$self->{'dtd'} = undef;

	# DTD file. 
	$self->{'dtd_file'} = undef;

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Is exists 'dtd_file' name.
	err "Cannot read file with DTD defined by 'dtd_file' paremeter."
		if ! $self->{'dtd_file'};

	# Is 'dtd_file' readable.
 	err "Cannot read file '$self->{'dtd_file'}' with DTD."
		if ! -r $self->{'dtd_file'};

	# DTD structure.
	if (! $self->{'dtd'}) {
		$self->{'dtd'} = ParseDTDFile($self->{'dtd_file'});
	}

	# Initialization.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub check($@) {
#------------------------------------------------------------------------------
# Check structure opposite dtd struct.

	my ($self, @data) = @_;
	foreach my $dat (@data) {
		$self->check_one($dat);
	}
}

#------------------------------------------------------------------------------
sub check_one($$) {
#------------------------------------------------------------------------------
# Detect and process one tag.

	my ($self, $data) = @_;

	# Attributes.
	if ($data->[0] eq 'a') {
		shift @{$data};
		while (@{$data}) {
			my $par = shift @{$data};
			my $val = shift @{$data};
		}

		# TODO

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		my $tag = $data->[1];

		# Tag non exists in dtd.
		if (! exists $self->{'dtd'}->{$tag}) {
			err "Tag '$tag' doesn't exist in dtd.";
		}

		# First tag.
		if ($#{$self->{'printed'}} == -1) {

			# Error with parent.
			if (exists $self->{'dtd'}->{$tag}->{'parent'}) {
				err "Tag '$tag' cannot be first.";
			}

		# Normal tag.
		} else {
			if (! exists $self->{'dtd'}->{$tag}->{'parent'}) {
				err "Tag '$tag' cannot be after other tag.";
			}

			my $prev_tag = $self->{'printed'}->[0];
			if (! grep { $prev_tag eq $_ } 
				@{$self->{'dtd'}->{$tag}->{'parent'}}) {

				err "Tag '$tag' cannot be after tag ".
					"'$prev_tag'.";
			}
		}

		# Printed.
		unshift @{$self->{'printed'}}, $tag;

	# End of tag.
	} elsif ($data->[0] eq 'e') {
		shift @{$self->{'printed'}};
	}
}

#------------------------------------------------------------------------------
sub reset($) {
#------------------------------------------------------------------------------
# Resets object.

	my $self = shift;

	# Parent stack.
	$self->{'printed'} = [];
}

1;

=pod

=head1 NAME

 Tags2::Process::Validator - Validator class for 'Tags2' structure.

=head1 SYNOPSIS

 use Tags2::Process::Validator;
 my $v = Tags2::Process::Validator(%params);
 $v->check(@data);
 $v->check_one($data);
 $v->reset;

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=over 8

=item B<dtd>

 DTD structure.

=item B<dtd_file>

 DTD file.
 Constructor reads DTD file, and structure saves to 'dtd' param.

=back

=item B<check(@data)>

 TODO

=item B<check($data)>

 TODO

=item B<reset()>

 Resets object.

=back

=head1 ERRORS

 Bad parameter '%s'.
 Cannot read file '%s' with DTD.
 Cannot read file with DTD defined by 'dtd_file' paremeter.
 Tag '%s' cannot be first.
 Tag '%s' cannot be after other tag.
 Tag '%s' cannot be after tag '%s'.
 Tag '%s' doesn't exist in dtd.
 TODO

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Process::Validator;

 TODO

=head1 REQUIREMENTS

 L<Error::Simple::Multiple(3pm)>.

=head1 SEE ALSO

 L<Tags2(3pm)>.

=head1 AUTHOR

 Michal Špaček L<tupinek@gmail.com>

=head1 VERSION 

 0.01

=cut
