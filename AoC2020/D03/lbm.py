from operator import mul
from functools import reduce
from math import ceil

def sumTrees(dx, dy, inp):
	return sum(1 if inp[dy*i][(dx*i)%len(inp[0])]=='#' else 0 for i in range(ceil(len(inp)/dy)))

def star1(inp):
	return sumTrees(3, 1, inp)

def star2(inp):
	slopes = [(1,1),(3,1),(5,1),(7,1),(1,2)]
	return reduce(mul, [sumTrees(dx, dy, inp) for (dx, dy) in slopes])

with open("input3.txt") as f:
	inp = f.read().splitlines()

print("Star 1:", star1(inp))	
print("Star 2:", star2(inp))
