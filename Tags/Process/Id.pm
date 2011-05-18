package Tags::Process::Id;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use List::MoreUtils qw(none);
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Process params.
	set_params($self, @params);

	# Initialization.
	$self->reset;

	# Object.
	return $self;
}

# Check 'Tags' structure opposit id attributes.
sub check {
	my ($self, @data) = @_;

	# For every 'Tags' structure.
	foreach my $data (@data) {

		# Begin of tag.
		if ($data->[0] eq 'b') {
			$self->{'actual_tag'} = $data->[1];

		# Tag attribute.
		} elsif ($data->[0] eq 'a') {
			shift @{$data};
			$self->_check_atributes_for_id($data);

		# End of tag.
		} elsif ($data->[0] eq 'e') {
			$self->{'actual_tag'} = $EMPTY_STR;
			$self->{'log'} = 0;
		}
	}
	return;
}

# Resets class id register.
sub reset {
	my $self = shift;

	# Actual tag.
	$self->{'actual_tag'} = undef;

	# Class id register array.
	$self->{'id_tags'} = [];

	# Log flag for id in current tag.
	$self->{'log'} = 0;

	return;
}

# Check attribute for bad ids.
sub _check_atributes_for_id {
	my ($self, $data) = @_;
	foreach my $i (0 .. $#{$data}) {
		if ($i % 2 == 0 && $data->[$i] eq 'id') {
			if ($self->{'log'} == 1) {
				err 'Other id attribute in tag '.
					"'$self->{'actual_tag'}'.";
			} elsif (! scalar @{$self->{'id_tags'}}
				|| none { $_ eq $data->[$i + 1] }
				@{$self->{'id_tags'}}) {

				push @{$self->{'id_tags'}},
					$data->[$i + 1];
				$self->{'log'} = 1;
			} else {
				err "Id attribute '$data->[$i + 1]'".
					" in tag '$self->{'actual_tag'}'".
					' is duplicit over structure.';
			}
		}
	}
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags::Process::Id - Class to check id attributes.

=head1 SYNOPSIS

 use Tags::Process::Id;
 my $id = Tags::Process::Id->new;
 $id->check(
         ['b', 'tag'],
         ['a', 'id', 'id1'],
         ['a', 'id', 'id2'],
 );

=head1 DESCRIPTION

 Id in tags in document must be unique.

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=item C<check(@data)>

 Check tags2 structure.
 If is structure bad, turn error.

=item C<reset()>

 Resets class internal variables for id checking.

=back

=head1 ERRORS

 Mine:
   Id attribute '%s' in tag '%s' is duplicit over structure.
   Other id attribute in tag '%s'.

 From Class::Utils:
   Unknown parameter '%s'.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags::Process::Id;

 # Object.
 my $id = Tags::Process::Id->new;

 # Check bad tag with two ids.
 $id->check(
         ['b', 'tag'],
         ['a', 'id', 'id1'],
         ['a', 'id', 'id2'],
 );

 # Output:
 # Tags::Process::Id: Other id attribute in tag 'tag'.

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags::Process::Id;

 # Object.
 my $id = Tags::Process::Id->new;

 # Check bad tag with two ids.
 $id->check(
         ['b', 'tag'],
         ['a', 'id', 'id1'],
         ['e', 'tag'],
         ['b', 'tag'],
         ['a', 'id', 'id1'],
         ['e', 'tag'],
 );

 # Output:
 # Tags::Process::Id: Id attribute 'id1' in tag 'tag' is duplicit over structure.

=head1 DEPENDENCIES

L<Class::Utils(3pm)>,
L<Error::Pure(3pm)>,
L<List::MoreUtils(3pm)>.

=head1 SEE ALSO

L<Tags(3pm)>,
L<Tags::Output::Core(3pm)>,
L<Tags::Output::Raw(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
