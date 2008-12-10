#------------------------------------------------------------------------------
package Tags2::Utils::Preserve;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple;
use List::MoreUtils qw(any);
use Readonly;

# Constants.
Readonly::Scalar my $LAST_INDEX => -1;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Preserved tags.
	$self->{'preserved'} = [];

	# Process params.
        while (@params) {
                my $key = shift @params;
                my $val = shift @params;
                err "Bad parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Reset.
	$self->reset;

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub begin {
#------------------------------------------------------------------------------
# Process for begin of tag.

	my ($self, $tag) = @_;
	$self->save_previous;
	if (scalar @{$self->{'preserved'}}
		&& any { $tag eq $_ } @{$self->{'preserved'}}) {

		push @{$self->{'preserved_stack'}}, $tag;
		$self->{'preserved_flag'} = 1;
	}

	# Return preserved flag.
	return wantarray ? ($self->{'preserved_flag'},
		$self->{'prev_preserved_flag'}) : $self->{'preserved_flag'};
}

#------------------------------------------------------------------------------
sub save_previous {
#------------------------------------------------------------------------------
# Save previsou stay.

	my $self = shift;
	$self->{'prev_preserved_flag'} = $self->{'preserved_flag'};

	return;
}

#------------------------------------------------------------------------------
sub end {
#------------------------------------------------------------------------------
# Process for end of tag.

	my ($self, $tag) = @_;
	$self->save_previous;
	my $stack = $self->{'preserved_stack'};
	if (scalar @{$stack} && $tag eq $stack->[$LAST_INDEX]) {
		pop @{$stack};
		if (! scalar @{$stack}) {
			$self->{'preserved_flag'} = 0;
		}
	}

	# Return preserved flag.
	return wantarray ? ($self->{'preserved_flag'},
		$self->{'prev_preserved_flag'}) : $self->{'preserved_flag'};
}

#------------------------------------------------------------------------------
sub get {
#------------------------------------------------------------------------------
# Get preserved flag.

	my $self = shift;
	return wantarray ? ($self->{'preserved_flag'},
		$self->{'prev_preserved_flag'}) : $self->{'preserved_flag'};
}

#------------------------------------------------------------------------------
sub reset {
#------------------------------------------------------------------------------
# Resets.

	my $self = shift;

	# Preserved flag.
	$self->{'preserved_flag'} = 0;

	# Previsous preserved flag.
	$self->{'prev_preserved_flag'} = 0;

	# Preserved tag.
	$self->{'preserved_stack'} = [];

	return;
}

1;
