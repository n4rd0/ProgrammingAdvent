# number of partitions of n with elements at most 3 is (n+3)th tribonacci number 
# 0, 0, 1, 1, 2, 4, 7, 13, 24, 44...
# 1 -> 1 (1)
# 2 -> 2 (1+1, 2)
# 3 -> 4 (1+2, 2+1, 1+1+1, 3)
# 4 -> 7 (1+2+1, 2+1+1, 1+1+1+1, 3+1, 1+1+2, 2+2, 1+3)
def tribonacci(n):
	if n==1 or n==2:
		return 0
	elif n==3:
		return 1
	return tribonacci(n-1)+tribonacci(n-2)+tribonacci(n-3)

def star1(diffs):
	counter = [0,0]
	for num in diffs:
		if num == 1:
			counter[0] += 1
		else:
			counter[1] += 1
	return counter[0]*counter[1]

def star2(diffs):
	tribo = [tribonacci(n) for n in range(3,21)]
	counter = 1
	ones = 0
	for num in diffs:
		if num == 1:
			ones += 1
		else:
			counter *= tribo[ones]
			ones = 0
	return counter

with open("input10.txt") as f:
	inp = sorted(list(map(int, f.read().splitlines())))
	diffs = [inp[0]] + [inp[i+1]-inp[i] for i in range(len(inp)-1)] + [3]

print("Star 1:", star1(diffs))
print("Star 2:", star2(diffs))