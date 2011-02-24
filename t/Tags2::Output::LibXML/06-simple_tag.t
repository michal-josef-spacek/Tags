# Modules.
use Tags2::Output::LibXML;
use Test::More 'tests' => 4;

print "Testing: Simple tag without parameters (sgml version).\n";
my $obj = Tags2::Output::LibXML->new;
$obj->put(
	['b', 'MAIN'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN/>
END
is($ret, $right_ret);

print "Testing: Simple tag with parameters (sgml version).\n";
$obj->reset;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<MAIN id="id_value"/>
END
is($ret, $right_ret);

print "Testing: Simple tag without parameters (xml version).\n";
$obj->reset;
$obj->put(
	['b', 'main'],
	['e', 'main'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<main/>
END
is($ret, $right_ret);

print "Testing: Simple tag with parameters (xml version).\n";
$obj->reset;
$obj->put(
	['b', 'main'],
	['a', 'id', 'id_value'],
	['e', 'main'],
);
$ret = $obj->flush;
$right_ret = <<'END';
<?xml version="1.1" encoding="UTF-8"?>
<main id="id_value"/>
END
is($ret, $right_ret);
