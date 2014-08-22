use strict;
use warnings;

sub primes {
# dies if pop > 32767
local $_;
$_=1x~-pop,()=/1(?{s!\G(.{${\pos}}).!$1x!g})/g,s!1!print$/,2+pos!ge
}

sub fibo {
# spatial complexity is O(exp pop)
local $_;
$_=$";s!!'print y/ 0/x /,$/;s/x/ 0/g,'x pop!ee
}

sub fibo2 {
no warnings;
local $_;
s//0 1/;s!!q#/ /;$_=$'.$".($`+$');print$',$/;#x pop!ee
}

sub pascal {
no warnings;
local $_;
s//1
/;s!!'print,s/^|\d+ /$&+$\'.$"/ge;'x pop!ee
}

primes(100);
print $/;
fibo2(15);
pascal(10);
