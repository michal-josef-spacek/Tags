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
Readonly::Scalar my $EMPTY_STR => q{};

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

	my $data_r = shift;
	if (ref $data_r eq 'SCALAR') {
		${$data_r} = encode_entities(${$data_r}, '<>&');
	} elsif (ref $data_r eq 'ARRAY') {
		foreach my $one_data (@{$data_r}) {
			encode_base_entities(\$one_data);
		}
	} elsif (ref $data_r eq $EMPTY_STR) {
		return encode_entities($data_r, '<>&');
	} else {
		err 'Reference \''.(ref $data_r).'\' doesn\'t supported.';
	}
	return;
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

 use Tags2::Utils qw(encode_newline encode_base_entities set_params);
 my $string_with_encoded_newline = encode_newline("foo\nbar");
 my $string_with_encoded_entities = encode_base_entities('data & data');
 set_params($self, %parameters);

=head1 SUBROUTINES

=over 8

=item C<encode_newline($string)>

 Encode newline to '\n' string.

=item C<encode_base_entities($data_r)>

 Encode '<', '>' and '&' entities to '&..;' string.

 $data_r can be:
 - Scalar. Returns encoded scalar.
 - Scalar reference. Returns undef.
 - Array reference of scalars. Returns undef.

=item C<set_params($self, @params)>

 Sets object parameters to user values.
 If setted key doesn't exist in $self object, turn fatal error.
 $self - Object or hash reference.
 @params - Key, value pairs.

=back

=head1 ERRORS

 encode_newline():
   None.

 encode_base_entities():
   Reference '%s' doesn't supported.

 set_params():
   Unknown parameter '%s'.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Utils qw(encode_newline);

 # Input text.
 my $text = <<'END';
 foo
 bar
 END

 # Encode newlines.
 my $out = encode_newline($text);

 # In $out:
 # foo\nbar\n

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Utils qw(encode_base_entities);

 # Input data.
 my @data = ('&', '<', '>');

 # Encode.
 encode_base_entities(\@data);

 # In @data:
 # (
 #         '&amp;',
 #         '&lt;',
 #         '&gt;',
 # )

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags2::Utils qw(set_params);

 # Hash reference with default parameters.
 my $self = {
         'test' => 'default',
 };

 # Set params.
 set_params($self, 'test', 'real_value');

 # In $self->{'test'} will be 'real_value'.

 # Set bad params.
 set_params($self, 'bad', 'value');

 # Turn error >>Unknown parameter 'bad'.<<.

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
