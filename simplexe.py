import re, sys
from fractions import Fraction
from numpy import array

def base(p, n):
	return array([0+(i == p) for i in xrange(n)])

def index_max(_iter):
	return max(t[::-1] for t in enumerate(_iter))[1]

lines = sys.stdin.readlines()
vars = sorted({match.group() for match in re.finditer(r'[a-zA-Z]\w*', ''.join(lines))})

_ = []
for ln in xrange(len(lines)):
	line = re.sub(r'(?<=\d)\s*(?=[a-zA-Z\(])', '*', lines[ln].replace('z=', '(').replace('<=', '-(') + ')')
	coeffs = eval(line, dict((vars[i], base(i, len(vars) + 1)) for i in xrange(len(vars))))
	_.append(array(map(Fraction, list(coeffs[:-1] - coeffs[-1]) + list(base(ln - 1, len(lines) - 1)) + [-coeffs[-1]])))

cols = vars +   ['e' + str(x) for x in xrange(1, len(_))] + ['b']
lines = ['z'] + ['e' + str(x) for x in xrange(1, len(_))]

while True:
	x = index_max(_[0])
	if _[0][x] <= 0: break
	y = index_max(l[-1] and l[x] / l[-1] for l in _)

	print '\t'.join(['\n'] + cols).replace(cols[x], '[%s]' % cols[x])
	for label, line in zip(lines, _):
		print '\t'.join([label.replace(lines[y], '[%s]' % lines[y])] + map(str, line))
	
	(lines[y], cols[x]) = (cols[x], lines[y])
	_ = [l / l[x] if l is _[y] else l - _[y] * l[x] / _[y][x] for l in _]

