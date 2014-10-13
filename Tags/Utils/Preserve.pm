package Tags::Utils::Preserve;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use List::MoreUtils qw(any);
use Readonly;

# Constants.
Readonly::Scalar my $LAST_INDEX => -1;

# Version.
our $VERSION = 0.02;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Preserved tags.
	$self->{'preserved'} = [];

	# Process params.
	set_params($self, @params);

	# Initialization.
	$self->reset;

	# Object.
	return $self;
}

# Process for begin of tag.
sub begin {
	my ($self, $tag) = @_;
	$self->save_previous;
	if (scalar @{$self->{'preserved'}}
		&& any { $tag eq $_ } @{$self->{'preserved'}}) {

		push @{$self->{'preserved_stack'}}, $tag;
		$self->{'preserved_flag'} = 1;
	}

	# Return preserved flags.
	return wantarray
		? ($self->{'preserved_flag'}, $self->{'prev_preserved_flag'})
		: $self->{'preserved_flag'};
}

# Process for end of tag.
sub end {
	my ($self, $tag) = @_;
	$self->save_previous;
	my $stack = $self->{'preserved_stack'};
	if (scalar @{$stack} && $tag eq $stack->[$LAST_INDEX]) {
		pop @{$stack};
		if (! scalar @{$stack}) {
			$self->{'preserved_flag'} = 0;
		}
	}

	# Return preserved flags.
	return wantarray
		? ($self->{'preserved_flag'}, $self->{'prev_preserved_flag'})
		: $self->{'preserved_flag'};
}

# Get preserved flag.
sub get {
	my $self = shift;

	# Return preserved flags.
	return wantarray
		? ($self->{'preserved_flag'}, $self->{'prev_preserved_flag'})
		: $self->{'preserved_flag'};
}

# Resets.
sub reset {
	my $self = shift;

	# Preserved flag.
	$self->{'preserved_flag'} = 0;

	# Previsous preserved flag.
	$self->{'prev_preserved_flag'} = 0;

	# Preserved tag.
	$self->{'preserved_stack'} = [];

	return;
}

# Save previous stay.
sub save_previous {
	my $self = shift;
	$self->{'prev_preserved_flag'} = $self->{'preserved_flag'};
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags::Utils::Preserve - TODO

=head1 SYNOPSIS

 use Tags::Utils::Preserve;
 my $t = Tags::Utils::Preserve->new(%params);
 # TODO

=head1 METHODS

=over 8

=item C<new(%params)>

 Constructor.

=over 8

=item * C<preserved>

 TODO

=back

=item C<begin()>

 TODO

=item C<end()>

 TODO

=item C<get()>

 TODO

=item C<reset()>

 TODO

=item C<save_previous()>

 TODO

=back

=head1 ERRORS

 Mine:
         TODO
 
 From Class::Utils::set_params():
         Unknown parameter '%s'.

=head1 EXAMPLE

 TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<List::MoreUtils>,
L<Readonly>.

=head1 SEE ALSO

L<Tags>,
L<Tags::Output>,
L<Tags::Output::ESIS>,
L<Tags::Output::Indent>,
L<Tags::Output::LibXML>,
L<Tags::Output::PYX>,
L<Tags::Output::Raw>,
L<Tags::Output::SESIS>,
L<Tags::Utils>.

=head1 REPOSITORY

L<https://github.com/tupinek/Tags>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz/>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.02

=cut
