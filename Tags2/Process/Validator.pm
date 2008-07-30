#------------------------------------------------------------------------------
package Tags2::Process::Validator;
#------------------------------------------------------------------------------
# $Id: Validator.pm,v 1.6 2008-07-30 22:43:42 skim Exp $

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

	# Is exist file for dtd?
	err "Cannot read file '$self->{'dtd_file'}' with DTD."
		if $self->{'dtd_file'} eq '' || ! -r $self->{'dtd_file'};

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

	# Begin of tag.
	} elsif ($data->[0] eq 'b') {
		$self->{'actual_tag'} = $data->[1];

	# End of tag.
	} elsif ($data->[0] eq 'e') {
	}
}

#------------------------------------------------------------------------------
sub reset($) {
#------------------------------------------------------------------------------
# Resets object.

	my $self = shift;

	# Actual tag.
	$self->{'actual_tag'} = undef;
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
