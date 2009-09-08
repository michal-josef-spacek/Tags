#------------------------------------------------------------------------------
package Tags2::Utils;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use HTML::Entities;
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(encode_newline encode_base_entities
	set_params);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub encode_newline {
#------------------------------------------------------------------------------
# Encode newline in data to '\n' in output.

	my $string = shift;
	$string =~ s/\n/\\n/gms;
	return $string;
}

#------------------------------------------------------------------------------
sub encode_base_entities {
#------------------------------------------------------------------------------
# Encode '<>&' base entities.
# TODO Other types.

	my $data_r = shift;
	if (ref $data_r eq 'SCALAR') {
		${$data_r} = encode_entities(${$data_r}, '<>&');
		return;
	} elsif (ref $data_r eq 'ARRAY') {
		foreach my $one_data (@{$data_r}) {
			encode_base_entities(\$one_data);
		}
	} else {
		return encode_entities($data_r, '<>&');
	}
}

#------------------------------------------------------------------------------
sub set_params {
#------------------------------------------------------------------------------
# Set parameters to user values.

	my ($self, @params) = @_;
	while (@params) {
		my $key = shift @params;
		my $val = shift @params;
		if (! exists $self->{$key}) {
			err "Unknown parameter '$key'.";
		}
		$self->{$key} = $val;
	}
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags2::Utils - Utils module for Tags2.

=head1 SYNOPSIS

 use Tags2::Utils qw(encode_newline encode_base_entities);
 TODO

=head1 SUBROUTINES

=over 8

=item C<encode_newline($string)>

 TODO

=item C<encode_base_entities($data_r)>

 TODO

=item C<set_params($self, @params)>

 Sets object parameters to user values.
 If setted key doesn't exist in $self object, turn fatal error.
 $self - Object or hash reference.
 @params - Key, value pairs.

=back

=head1 ERRORS

 set_params()
   Unknown parameter '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Utils qw(TODO);

 TODO

=head1 DEPENDENCIES

L<HTML::Entities(3pm)>,
L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Tags2(3pm)>,
L<Tags2::Output::Core(3pm)>,
L<Tags2::Output::ESIS(3pm)>,
L<Tags2::Output::Indent(3pm)>,
L<Tags2::Output::LibXML(3pm)>,
L<Tags2::Output::PYX(3pm)>,
L<Tags2::Output::Raw(3pm)>,
L<Tags2::Output::SESIS(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
