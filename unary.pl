#!/usr/bin/env perl -l

use strict;
use warnings;
$" = '|';

sub combinations {
	my $n = shift() - 1;
	(@_, $n ? map {my $c = $_; map {"$c$_"} @_} combinations($n, @_) : ());
}

compare();
dec2un();

#######
# Number comparison
#######

sub compare {
	my @shorter = map "\\d{$_},0*+\\d{$_}\\d+", 0..4;
	my @longer = map "\\d{$_}\\d+,0*+\\d{$_}\$", 0..4;
	my @same = map "\\d{$_},0*+\\d{$_}\$", 1..5;
	my @lesser = map "$_\\d*,0*+\\1[${\++$_}-9]", 0..8;
	my @greater = map "$_\\d*,0*+\\1[0-${\--$_}]", 1..9;

	my $lt = qr/^ 0*+ (?: @shorter | (?=@same) (\d*) (?:@lesser))/x;
	my $gt = qr/^ 0*+ (?: @longer | (?=@same) (\d*) (?:@greater))/x;

	print "100,100" =~ /$gt/ ? "Yay" : "Nay";
	print "122,111" =~ /$gt/ ? "Yay" : "Nay";
	print "2,10"    =~ /$gt/ ? "Yay" : "Nay";
	print "3,0"    =~ /$gt/ ? "Yay" : "Nay";

	for $a (0..200, 1000, 10000) {
		for $b (0..200, 1000, 10000) {
			for ("$a,$b", "0$a,$b", "$a,0$b", "0$a,0$b") {
				die $_ if ($a > $b) != /$gt/;
				die $_ if ($a < $b) != /$lt/;
			}
		}
	}
}

########
# Infinite regex
########

# Pattern subroutine nesting without pos change exceeded limit
# Infinite recursion
# Variable length lookbehind not implemented

sub infinite {
	/(.(?2))((?<=(?=(?1)).))/xsm;
}

########
# Multiplication
########

my $mult = qr/^(1+)x(=|1(?2)\1)$/;

########
# Powers
########

sub powers {
	my $powers = qr/^(1$|(1+)\2(?=\2$)(?1))/;
	print for grep {(1x$_)=~/$powers/} 0..100;
}

########
# Bases
########

sub bin2un {
	my $r2 = qr/\A [01]*? ([01]) (.*) = (\1?+ (?(3)\3\3)) \z \2 (?>!0) (?!\3)/xsm;
	map {print if /$r2/} combinations 5, 0..2, '=', "\n", 'a';
}

sub dec2un {
	my @digits = 0..9;
	my $base = @digits;
	@digits = map qr{$digits[$_] (.*?) = ( (?(2)\2{$base}) 1{$_} )}x, 0..$#digits;
	my $r10 = qr/\A .*? (?>(?| @digits | (*PRUNE)(*FAIL) )) \z \1/xsm;

	map {print if /$r10/} combinations 4, 0..9, '=', "\n", 'a';
	map {print if /$r10/} map {"19=" . 1x$_} 0..100;
}
