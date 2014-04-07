use Math::BigRat;
$, = "\t";
$\ = $/;

for (<DATA>) {
	s/\s//g;
	push @_, { map { /[a-z]\d?|$/; \$vars{$&}; $& => $` || 1 } /[+-]?\d+\w*/g };
}

print "$k => $v\n" while ($k, $v) = each %{$_[1]};
@vars = sort grep $_, keys %vars;
@_ = map { [ map Math::BigRat->new($_), @$_{@vars, (0)x$#_, ''}] } @_;
map {$_[$_][$#vars+$_]++} 1..$#_;


@cols  = (@vars, (map "e$_", 1..$#_), b);
@lines = (z, map "e$_", 1..$#_);


while (1) {
	print $/, @cols;
	print $lines[$_], @{$_[$_]} for 0..$#_;
	
	$m = 0;
	map { $x = $_, $m = $_[0][$_] if $_[0][$_] > $m } 0..$#{$_[0]};
	last if !$m;
	
	$m = 0;
	map { $y = $_, $m = $t if $_[$_][-1] && ($t = $_[$_][$x] / $_[$_][-1]) > $m } 1..$#_;
	$lines[$y] = $cols[$x];
	$pivot = $_[$y][$x];
	map { $_ /= $pivot } @{$_[$y]};
	
	for (0..$#_) {
		next if $_ == $y;
		$k = $_[$_][$x] / $_[$y][$x];
		$ligne = $_[$_];
		map { $ligne->[$_] -= $k * $_[$y][$_] } 0..$#$ligne;
	}
}


__DATA__
Maximiser Z=5 x1+4 x 2+3 x3
5x1+3 x2+1x3⩽5
4 x1+1x2+2 x3⩽11
3 x1+4 x2+2 x3⩽8