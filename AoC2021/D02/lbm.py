from re import findall
from functools import reduce
from operator import mul

def f1(e1, e2):
    x, y = e1
    d, val = e2
    return                               \
             (x, y - val) if d == 'up'   \
        else (x, y + val) if d == 'down' \
        else (x + val, y)

def f2(e1, e2):
    aim, x, y = e1
    d, val = e2
    return                                    \
             (aim - val, x, y) if d == 'up'   \
        else (aim + val, x, y) if d == 'down' \
        else (aim, x + val, y + aim * val)

inp = [(d, int(val)) for d, val in findall(r'(\w+) (\d+)\n', open('input.txt', 'r').read())]
print('Star 1:', reduce(mul, reduce(f1, inp, (0, 0))))
print('Star 2:', reduce(mul, reduce(f2, inp, (0, 0, 0))[1:]))
