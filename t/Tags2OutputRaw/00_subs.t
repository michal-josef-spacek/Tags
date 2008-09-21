# Modules.
use IO::Scalar;

#------------------------------------------------------------------------------
sub go($$@) {
#------------------------------------------------------------------------------
# Helper function to print.

	my $class = shift;
	my $val = shift;

	my $stdout;
	tie *STDOUT, 'IO::Scalar', \$stdout;
	eval {
		$class->put(@_);
		$class->flush;
	};
	my $stderr = $@;
	untie *STDOUT;

	# Output.
	if ($val == 1) {
		return $stdout;
	} elsif ($val == 2) {
		return $stderr;
	} else {
		return ($stdout, $stderr);
	}
}
