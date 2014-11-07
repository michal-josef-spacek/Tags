package Tags::Utils::Preserve;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use List::MoreUtils qw(any);
use Readonly;

# Constants.
Readonly::Scalar my $LAST_INDEX => -1;

# Version.
our $VERSION = 0.03;

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
 my $obj = Tags::Utils::Preserve->new(%params);
 my $preserved_flag = $obj->begin;
 my ($preserver_flag, $prev_preserved_flag) = $obj->begin;
 my $preserved_flag = $obj->end;
 my ($preserved_flag, $prev_preserved_flag) = $obj->end;
 $obj->get;
 $obj->reset;
 $obj->save_previous;

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

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags::Utils::Preserve;

 # Begin element helper.
 sub begin_helper {
         my ($pr, $tag) = @_;
         print "TAG: $tag ";
         my ($pre, $pre_pre) = $pr->begin($tag);
         print "PRESERVED: $pre PREVIOUS PRESERVED: $pre_pre\n";
 }
 
 # End element helper.
 sub end_helper {
         my ($pr, $tag) = @_;
         print "ENDTAG: $tag ";
         my ($pre, $pre_pre) = $pr->end($tag);
         print "PRESERVED: $pre PREVIOUS PRESERVED: $pre_pre\n";
 
 }
 
 # Object.
 my $pr = Tags::Utils::Preserve->new(
         'preserved' => ['tag']
 );
 
 # Process.
 begin_helper($pr, 'foo');
 begin_helper($pr, 'tag');
 begin_helper($pr, 'foo');
 end_helper($pr, 'foo');
 end_helper($pr, 'tag');
 end_helper($pr, 'foo');

 # Output:
 # TAG: foo PRESERVED: 0 PREVIOUS PRESERVED: 0
 # TAG: tag PRESERVED: 1 PREVIOUS PRESERVED: 0
 # TAG: foo PRESERVED: 1 PREVIOUS PRESERVED: 1
 # ENDTAG: foo PRESERVED: 1 PREVIOUS PRESERVED: 1
 # ENDTAG: tag PRESERVED: 0 PREVIOUS PRESERVED: 1
 # ENDTAG: foo PRESERVED: 0 PREVIOUS PRESERVED: 0

=head1 DEPENDENCIES

L<Class::Utils>,
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

BSD 2-Clause License

=head1 VERSION

0.03

=cut
