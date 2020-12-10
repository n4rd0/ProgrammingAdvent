from functools import reduce
# number of partitions of n with elements at most 3 is (n+3)th tribonacci number 
# 0, 0, 1, 1, 2, 4, 7, 13, 24, 44...
# 1 -> 1 (1)
# 2 -> 2 (1+1, 2)
# 3 -> 4 (1+2, 2+1, 1+1+1, 3)
# 4 -> 7 (1+2+1, 2+1+1, 1+1+1+1, 3+1, 1+1+2, 2+2, 1+3)
def tribonacciUpTo(nth):
	tribo = [0,0,1]

	if nth <= 2:
		return tribo[nth]

	for i in range(3, nth+1):
		tribo.append(tribo[i-1]+tribo[i-2]+tribo[i-3])

	return tribo

def star1(diffs):
	ones, threes = reduce(lambda acc, x: [acc[0]+1, acc[1]] if x == 1 else [acc[0], acc[1]+1], diffs, [0,0])
	return ones*threes

def star2(diffs):
	tribo = tribonacciUpTo(6)[2:]
	return reduce(lambda acc, x: [acc[0], acc[1]+1] if x == 1 else [acc[0]*tribo[acc[1]], 0] , diffs, [1,0])[0]

with open("input10.txt") as f:
	inp = sorted(list(map(int, f.read().splitlines())))
	diffs = [inp[0]] + [inp[i+1]-inp[i] for i in range(len(inp)-1)] + [3]

print("Star 1:", star1(diffs))
print("Star 2:", star2(diffs))