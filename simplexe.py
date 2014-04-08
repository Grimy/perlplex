import re, sys
from fractions import Fraction

rx = re.compile(r'([-+]?)(\d*)([a-zA-Z]\w+)?')
lines = [line.replace(' ', '') for line in sys.stdin.readlines()]
vars = sorted({match.group(3) for match in rx.finditer(''.join(lines))} - {None})
_ = [dict((match.group(3), match.group(1) + (match.group(2) or '1')) for match in rx.finditer(line)) for line in lines]
print _
_ = [[Fraction(coeffs.get(var, 0)) for var in vars + range(1, len(_)) + [None]] for coeffs in _]
for x in xrange(1, len(_)):
	_[x][len(vars) - 1 + x] = 1

exit(0)

cols = vars +   ['e' + str(x) for x in xrange(1, len(_))] + ['b']
lines = ['z'] + ['e' + str(x) for x in xrange(1, len(_))]

m = 1
while m > 0:
	m, y = max(t[::-1] for t in enumerate(l[-1] and l[x] / l[-1] for l in _))
	m, x = max(t[::-1] for t in enumerate(_[0]))
	print x, y

	print '\t'.join(['\n'] + [('[%s]' if i == x else '%s') % cols[i] for i in xrange(len(cols))])
	for label, line in zip(lines, _):
		print '\t'.join([label] + map(str, line))
	
	(lines[y], cols[x]) = (cols[x], lines[y])
	_[y] = [t / _[y][x] for t in _[y]]

	for i in set(xrange(len(_))) - {y}:
		_[i] = [j[0] - _[i][x] * j[1] for j in zip(_[i], _[y])]

