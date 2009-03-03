# Modules.
use Tags2::Output::LibXML;
use Test::More 'tests' => 1;

print "Testing: Raw.\n";
my $obj = Tags2::Output::LibXML->new;
$obj->put(
	['b', 'tag'],

	# Ignore for this module.
	['r', 'Raw'],

	['e', 'tag'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<tag/>
END
is($ret, $right_ret);
