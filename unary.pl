#!/usr/bin/env perl -l

use strict;
use warnings;
$" = '|';

#######
# Number comparison
#######

my @shorter = map "\\d{$_}<0*+\\d{$_}\\d+", 0..4;
my @same = map "\\d{$_}<0*+\\d{$_}", 1..5;
my @digits = map "$_\\d*<0*+\\1[${\++$_}-9]", 0..8;
my $lt = qr/^ 0*+ (?: @shorter | (?=@same) (\d*) (?:@digits))/x;

# my $lt = qr/^ 0*+
	# (?: \d{0} < 0*+ \d{0}\d+
	  # | \d{1} < 0*+ \d{1}\d+
	  # | \d{2} < 0*+ \d{2}\d+
	  # | \d{3} < 0*+ \d{3}\d+
	  # | \d{4} < 0*+ \d{4}\d+
	  # | (?= \d{1} < 0*+ \d{1}
	      # | \d{2} < 0*+ \d{2}
	      # | \d{3} < 0*+ \d{3}
	      # | \d{4} < 0*+ \d{4}
	      # | \d{5} < 0*+ \d{5}
	      # ) (\d*)
	    # (?: 0 \d* < 0*+ \1 [1-9]
	      # | 1 \d* < 0*+ \1 [2-9]
	      # | 2 \d* < 0*+ \1 [3-9]
	      # | 3 \d* < 0*+ \1 [4-9]
	      # | 4 \d* < 0*+ \1 [5-9]
	      # | 5 \d* < 0*+ \1 [6-9]
	      # | 6 \d* < 0*+ \1 [7-9]
	      # | 7 \d* < 0*+ \1 [8-9]
	      # | 8 \d* < 0*+ \1 [9-9]
	      # )
	  # )
# /x;

print "100<100" =~ /$lt/ ? "Yay" : "Nay";
print "122<111" =~ /$lt/ ? "Yay" : "Nay";
print "10<2" =~ /\d+ ( <0*+ | \d (?1) \d) $/xsm;

for $a (0..1000) {
	for $b (0..1000) {
		for ("$a<$b", "0$a<$b", "$a<0$b", "0$a<0$b") {
			die $_ if !($a < $b) != !/$lt/;
		}
	}
}

__END__

########
# Infinite regex
########

# Pattern subroutine nesting without pos change exceeded limit
# Infinite recursion
# Variable length lookbehind not implemented

# /(.(?2))((?<=(?=(?1)).))/xsm

########
# Multiplication
########

my $mult = qr/^(1+)x(=|1(?2)\1)$/;

########
# Powers
########

my $powers = qr/^(1$|(1+)\2(?=\2$)(?1))/;
print for grep {(1x$_)=~/$powers/} 0..100;
print "=" x 80;

sub combinations {
	my $n = shift() - 1;
	(@_, $n ? map {my $c = $_; map {"$c$_"} @_} combinations($n, @_) : ());
}

my $r2 = qr/\A [01]*? ([01]) (.*) = (\1?+ (?(3)\3\3)) \z \2 (?>!0) (?!\3)/xsm;
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
