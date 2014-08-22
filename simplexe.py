""" Solver for linear optimization problems """
import re, sys
from fractions import Fraction
from numpy import array, eye, vstack

def parse(text):
    """ Parses the specified textual representation of the system.
    Returns a 3-tuple: (system, column_labels, line_labels) """
    text = text.replace('z=', '(').replace('<=', '-(').replace('\n', ')\n')
    names = sorted({m.group() for m in re.finditer(r'[a-zA-Z]\w*', text)})
    text = re.sub(r'(\d)\s*([a-zA-Z\(])', r'\1*\2', text)
    text = re.sub(r'(?<!\w)(\d*\.?\d+)', r'Fraction("\1")', text)

    dic = dict(zip(names, -eye(len(names) + 1, dtype=int)))
    _ = vstack([eval(line, dic, globals()) for line in text.splitlines()]).T

    return (vstack([_[-1] - _[:-1], eye(len(_.T), dtype=int)[1:], -_[-1]]).T,
            names +   ['e' + str(x) for x in xrange(1, len(_))] + ['b'],
            ['z'] + ['e' + str(x) for x in xrange(1, len(_))])

def solve(_):
    """ Solves the specified system """
    while True:
        x = _[0].argmax()
        y = array([l[-1] and l[x] / l[-1] for l in _]).argmax()

        yield (_, x, y)
        if _[0, x] <= 0:
            return
        
        _[y] /= _[y, x]
        _ -= _[y] * _[:, [x]] * (1 - eye(len(_), dtype=int))[:, [y]]

def main(text):
    """ Pretty-prints the solution """
    system, cols, lines = parse(text)
    for (_, x, y) in solve(system):
        print re.sub(r'\b(%s)\b' % cols[x], r'[\1]', '\t'.join(['\n'] + cols))
        for label, line in zip(lines, _):
            print '\t'.join([re.sub(r'\b(%s)\b' % lines[y], r'[\1]', label)] + map(str, line))
        (lines[y], cols[x]) = (cols[x], lines[y])

if __name__ == '__main__':
    main(sys.stdin.read())

