def count_increasing(l):
    return sum(a < b for a, b in zip(l, l[1:]))

inp = [int(line) for line in open('input.txt', 'r').read().splitlines()]
print('Star 1:', count_increasing(inp))
print('Star 2:', count_increasing([sum(window) for window in zip(inp, inp[1:], inp[2:])]))
