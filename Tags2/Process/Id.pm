#------------------------------------------------------------------------------
package Tags2::Process::Id;
#------------------------------------------------------------------------------
# $Id: Id.pm,v 1.2 2007-02-21 00:19:07 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new($@) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Class id register array.
	$self->{'id_tags'} = [];

	# Actual tag.
	$self->{'actual_tag'} = '';

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub check($@) {
#------------------------------------------------------------------------------
# Check 'Tags2' structure opposit id attributes.

	my ($self, @data) = @_;

	# For every 'Tags2' structure.
	foreach my $data (@data) {

		# Begin of tag.
		if ($data->[0] eq 'b') {
			$self->{'actual_tag'} = $data->[1];

		# Tag attribute.
		} elsif ($data->[0] eq 'a') {
			shift @{$data};
			$self->_check_atributes_for_id($data);
		}
	}
	
}

#------------------------------------------------------------------------------
sub reset($) {
#------------------------------------------------------------------------------
# Resets class id register.

	my $self = shift;
	$self->{'id_tags'} = [];
	$self->{'actual_tag'} = '';
}

#------------------------------------------------------------------------------
# Internal methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _check_atributes_for_id($$) {
#------------------------------------------------------------------------------
# Check attribute for bad ids.

	my ($self, $data) = @_;
	my $log = 0;
	for (my $i = 2; $i <= $#{$data}; $i++) {
		if ($i % 2 == 0 && $data->[$i] eq 'id') {
			if ($log == 1) {
				err "Other id attribute in tag ".
					"'$self->{'actual_tag'}'.";
			} elsif (! grep { $_ eq $data->[$i + 1] }
				@{$self->{'id_tags'}}) {

				push @{$self->{'id_tags'}},
					$data->[$i + 1];	
				$log = 1;
			} else {
				err "Id attribute '$data->[$i + 1]'".
					" in tag '$self->{'actual_tag'}'".
					" is duplicit over structure.";
			}
		}
	}
}

1;

=pod

=head1 NAME

 Tags2::Process::Id - Class to check id attributes.

=head1 SYNOPSIS

 use Tags2::Process::Id;
 my $id = Tags2::Process::Id->new;
 $id->check(
   ['b', 'tag'],
   ['a', 'id', 'id1'],
   ['a', 'id', 'id2'],
 );

=head1 DESCRIPTION

 Id in tags in document must be unique.

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=item B<check()>

 TODO

=item B<reset()>

 Resets class internal variables for id checking.

=back

=head1 EXAMPLE

 TODO

=head1 REQUIREMENTS

 L<Error::Simple::Multiple>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION 

 0.01

=cut
