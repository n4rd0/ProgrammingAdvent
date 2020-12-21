import sys

#Star 1 with loops
"""
def star1(inp):
	for index, num in enumerate(inp[25:], 25):
		last25 = inp[index-25:index]
		if not any(True for n in last25 if num-n!=n and num-n in last25):
			print("Star 1:", num)
			return num
"""

#Star 2 with loops
"""
def star2(inp, num):
	for i in range(2, len(inp)+1):
		for j in range(len(inp)-i + 1):
			group = inp[j:j+i+1]
			if sum(group) == num:
				return max(group)+min(group)
"""

def star1(inp):
	if len(inp) == 25:
		return 0
	if not isSum(inp[:25], inp[25]):
		print("Star 1:", inp[25])
		return inp[25]

	return star1(inp[1:])

def isSum(inp, num, i = 0):
	if i == len(inp):
		return False

	return (num - inp[i] in inp and num - inp[i] != inp[i]) or isSum(inp, num, i+1)

def star2(inp, num, i = 2):
	if i == len(inp)+1:
		return 0

	found, result = checkSums(inp, num, i)
	if found:
		return result

	return star2(inp, num, i+1)

def checkSums(inp, num, i):
	if len(inp) < i:
		return (False, 0)
	elif sum(inp[:i+1]) == num:
		return (True, max(inp[:i+1]) + min(inp[:i+1]))

	return checkSums(inp[1:], num, i)

with open("input9.txt") as f:
	inp = list(map(int, f.read().splitlines()))

#Small groups of elements exceed default recursion limit of 1000
sys.setrecursionlimit(sys.getrecursionlimit() + 100)
print("Star 2:", star2(inp, star1(inp)))