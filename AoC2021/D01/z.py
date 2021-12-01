import sys

with open(sys.argv[1]) as f:
	measurements = [int(m) for m in f.read().splitlines()]

def solve_part1():
	sol = 0
	for i in range(1,len(measurements)):
		sol += measurements[i-1] < measurements[i] 

	print(sol)

def solve_part2():
	sol = 0
	for i in range(0,len(measurements)-1):
		cur = sum([measurements[i + j] for j in range(3) if i+j < len(measurements)])
		next_cur = sum([measurements[i + j + 1] for j in range(3) if i+j + 1 < len(measurements)])
		sol += cur < next_cur
	
	print(sol)

solve_part1()
solve_part2()
