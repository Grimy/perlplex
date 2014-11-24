#!/usr/bin/perl -nlaw
use strict;

BEGIN {@ARGV = 'hands'} push @@, [@F] }{

my @hand;
my %ok = ();

my @tree = ([], [reverse 0..21]);

for my $card (2..10) {
	$tree[$card] = [(0) x 22];
	for my $sum (reverse 0..21) {
		$tree[$card][$sum] += ($tree[$card - 1][$sum + 1] // 0);
		$tree[$card][$sum] += ($tree[$card][$sum + $card] // 0);
	}
}
print "@$_" for @tree;

my @trans;

for (@@) {
	my @hand = @$_;
	my $hash = 0;
	my $sum = 0;
	for (reverse 1..10) {
		$hash += $tree[$_][$sum += $_ * $hand[$_]];
	}
	for my $card (1..10) {
		$hand[$card]++;
		my $newhash = 0;
		my $sum = 0;
		for (reverse 1..10) {
			$sum += $_ * $hand[$_];
			$newhash = $sum > 21 ? 3083 : $newhash + $tree[$_][$sum];
		}
		$trans[$hash][$card] = $newhash;
		$hand[$card]--;
	}
}

sub check_hash {
	my $hash = 3082;
	my $sum = 0;

	for my $card (1..10) {
		for (1..$hand[$card]) {
			$hash = $trans[$hash][$card];
		}
	}

	return if $sum > 21;
	if ($ok{$hash}) {
		my @reverse = @{$ok{$hash}};
		die "@reverse ne @hand" if "@reverse" ne "@hand";
		return;
	}

	$ok{$hash} = [@hand];
}

for (@@) {
	@hand = @$_;
	check_hash();
}

@keys = sort {$a <=> $b} keys %ok;
print $keys[-1];
print scalar keys %ok;
