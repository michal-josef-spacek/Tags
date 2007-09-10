#------------------------------------------------------------------------------
package Tags2::Utils::Preserve;
#------------------------------------------------------------------------------
# $Id: Preserve.pm,v 1.1 2007-09-10 21:04:06 skim Exp $

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

	# Preserved tags.
	$self->{'preserved'} = [];

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Bad parameter '$key'." unless exists $self->{$key};
                $self->{$key} = $val;
        }

	# Reset.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub begin_tag($$) {
#------------------------------------------------------------------------------
# Process for begin of tag.

	my ($self, $tag) = @_;
	if (grep { $tag eq $_ } @{$self->{'preserved'}}
		|| $self->{'preserved_flag'}) {

		push @{$self->{'preserved_stack'}}, $tag;
		$self->{'preserved_flag'} = 1 unless $self->{'preserved_flag'};
	}

	# Return preserved flag.
	return $self->{'preserved_flag'};
}

#------------------------------------------------------------------------------
sub end_tag($$) {
#------------------------------------------------------------------------------
# Process for end of tag.

	my ($self, $tag) = @_;
	my $stack = $self->{'preserved_stack'};
	if ($tag eq $stack->[$#{$stack}]) {
		pop @{$stack};
		if ($#{$stack} == -1) {
			$self->{'preserved_flag'} = 0;
		}
	}
}

#------------------------------------------------------------------------------
sub reset($) {
#------------------------------------------------------------------------------
# Resets.

	my $self = shift;

	# Preserved flag.
	$self->{'preserved_flag'} = 0;

	# Preserved tag.
	$self->{'preserved_stack'} = [];
}

1;
