#!/usr/bin/perl -wn

use 5.14.2;

sub assert { $_[0] eq $_[1] or die "$_[0] != $_[1]\n$`\n", map show($_) . "\n", @; }
sub show { $_[0][0] ? "Arity $_[0][0]" : $_[0][1]->() }
sub poppy { @; ? pop @; : die "Pop on empty stack" }

# Primitives
$_{0} = [0, sub { 0 }];
$_{s} = [1, sub { 1+pop }];

# Rules
$({")"} = sub {
	my $f = pop @;;
	assert(pop @(, @;-$$f[0] . '(');
	my @g = splice @;, -$$f[0];
	assert($$_[0], $g[0][0]) for @@;
	[$g[0][0], sub {
			# say "(@_)";
			$$f[1]->(map &{$$_[1]}, @g) }]
};
$({"]"} = sub {
	assert(pop @(, @;-2 . '[');
	my($g, $f) = splice @;, -2;
	assert($$f[0], $$g[0]+2);
	my $r;
	$r = sub {
		# map { $_{$_}[1] == $r && print } keys %_; say " @_";
		my $a = shift; $a-- ? $$f[1]->($a, $r->($a, @_), @_) : &{$$g[1]} };
	[$$f[0]-1, $r]
};

'(['=~/\Q$&/ ? push @(, @; . $&
			 : push @;, $#-    ? [length $&, do { my $i = length $1; sub {$_[$i]}}]:
						$({$&} ? &{$({$&}}:
						($_{$&} //= &poppy)
while /(>*)X<*|[a-zA-Z]\w*|./g;

say $;[-1][1]->() unless $;[-1][0];
