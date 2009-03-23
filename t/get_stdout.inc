# Modules.
use English qw(-no_match_vars);
use IO::Scalar;

#------------------------------------------------------------------------------
sub get_stdout {
#------------------------------------------------------------------------------
# Helper function to print.

	my ($class, $val, @tags) = @_;

	my $stdout;
	tie *STDOUT, 'IO::Scalar', \$stdout;
	eval {
		$class->put(@tags);
		$class->flush;
	};
	my $stderr = $EVAL_ERROR;
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
