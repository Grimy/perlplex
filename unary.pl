#!/usr/bin/env perl -l

# Infinite regex : /(.(?2))((?<=(?=(?1)).))/xsm
# Pattern subroutine nesting without pos change exceeded limit
# Infinite recursion
# Variable length lookbehind not implemented

use strict;
use warnings;
$" = '|';

sub combinations {
	my $n = shift() - 1;
	(@_, $n ? map {my $c = $_; map {"$c$_"} @_} combinations($n, @_) : ());
}

my $r2 = qr/\A [01]*? ([01]) (.*) = (\1?+ (?(3)\3\3)) \z \2 (?<!0) (?!\3)/xsm;
map {print if /$r2/} combinations 5, 0..2, '=', "\n", 'a';
print "=" x 80;

# my $rec = qr/\A (= | ([01]) ((?1)) \3 \2?+) \z/xsm;
# map {print if /$rec/} combinations 5, 0..2, '=', "\n", 'a';
# print "=" x 80;

my @digits = 0..9;
my $base = @digits;
@digits = map qr{$digits[$_] (.*?) = ( (?(2)\2{$base}) 1{$_} )}x, 0..$#digits;
my $r10 = qr/\A .*? (?>(?| @digits | (*PRUNE)(*FAIL) )) \z \1/xsm;

map {print if /$r10/} combinations 4, 0..9, '=', "\n", 'a';
map {print if /$r10/} map {"19=" . 1x$_} 0..100;
