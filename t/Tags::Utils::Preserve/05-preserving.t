# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Utils::Preserve;
use Test::More 'tests' => 35;

# Test.
my $obj = Tags::Utils::Preserve->new;
my ($pre, $pre_pre) = $obj->get;
is($pre, 0);
is($pre_pre, 0);
($pre, $pre_pre) = $obj->begin('tag');
is($pre, 0);
is($pre_pre, 0);
($pre, $pre_pre) = $obj->end('tag');
is($pre_pre, 0);
is($pre, 0);

# Test.
$obj = Tags::Utils::Preserve->new(
	'preserved' => ['tag'],
);
($pre, $pre_pre) = $obj->get;
is($pre, 0);
is($pre_pre, 0);
($pre, $pre_pre) = $obj->begin('other_tag');
is($pre, 0);
is($pre_pre, 0);
($pre, $pre_pre) = $obj->begin('tag');
is($pre, 1);
is($pre_pre, 0);
($pre, $pre_pre) = $obj->begin('other_tag2');
is($pre, 1);
is($pre_pre, 1);
($pre, $pre_pre) = $obj->end('other_tag2');
is($pre, 1);
is($pre_pre, 1);
($pre, $pre_pre) = $obj->end('tag');
is($pre, 0);
is($pre_pre, 1);
($pre, $pre_pre) = $obj->end('other_tag');
is($pre, 0);
is($pre_pre, 0);

# Test.
$obj->reset;
$pre = $obj->get;
is($pre, 0);
$pre = $obj->begin('other_tag');
is($pre, 0);
$pre = $obj->begin('tag');
is($pre, 1);
$pre = $obj->begin('other_tag2');
is($pre, 1);
$pre = $obj->end('other_tag2');
is($pre, 1);
$pre = $obj->end('tag');
is($pre, 0);
$pre = $obj->end('other_tag');
is($pre, 0);

# Test.
$obj->reset;
$obj->begin('other_tag');
$obj->begin('tag');
$obj->begin('other_tag2');
($pre, $pre_pre) = $obj->get;
is($pre, 1);
is($pre_pre, 1);
$obj->reset;
($pre, $pre_pre) = $obj->get;
is($pre, 0);
is($pre_pre, 0);

# Test.
$obj->reset;
$obj->begin('other_tag');
($pre, $pre_pre) = $obj->begin('tag');
is($pre, 1);
is($pre_pre, 0);
$obj->save_previous;
($pre, $pre_pre) = $obj->get;
is($pre, 1);
is($pre_pre, 1);
