use Math::BigRat;
$, = "\t";
$\ = $/;

@_ = map { s/\s//g; +{ map { /[a-z]\d?|$/; \$vars{$&}; $& => $` || 1 } /[+-]?\d+\w*/g } } <>;
@vars = sort grep $_, keys %vars;
@_ = map { [ map Math::BigRat->new($_), @$_{@vars, (0)x$#_, ''}] } @_;
map {$_[$_][$#vars+$_]++} 1..$#_;

@cols  = (@vars, (map "e$_", 1..$#_), b);
@lines = (z, map "e$_", 1..$#_);

for (;;) {
	print $/, @cols;
	print $lines[$_], @{$_[$_]} for 0..$#_;
	
	$m = 0;
	map { $x = $_, $m = $_[0][$_] if $_[0][$_] > $m } 0..$#{$_[0]};
	last if !$m;
	
	$m = 0;
	map { $y = $_, $m = $t if $_[$_][-1] && ($t = $_[$_][$x] / $_[$_][-1]) > $m } 1..$#_;
	$lines[$y] = $cols[$x];
	$_[$y] = [ map { $_ / $_[$y][$x] } @{$_[$y]} ];
	
	for (0..$#_) {
		next if $_ == $y;
		$k = $_[$_][$x];
		$ligne = $_[$_];
		map { $ligne->[$_] -= $k * $_[$y][$_] } 0..$#$ligne;
	}
}

