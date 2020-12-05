def parseInput(file):
	toBinary = {"B" : "1", "F" : "0", "R" : "1", "L" : "0"}
	with open(file) as f:
		inp = [ int("".join([toBinary[c] for c in line]), 2) for line in f.read().splitlines()]

	return inp

def star1(inp):
	return inp[-1]

def star2(inp, star):
	if inp[0] != star:
		return star
	
	return star2(inp[1:], star + 1)

inp = parseInput("input5.txt")
inp.sort()
print("Star 1:", star1(inp))
print("Star 2:", star2(inp, inp[0]))