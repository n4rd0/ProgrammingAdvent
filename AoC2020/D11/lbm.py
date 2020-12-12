def star1(last, square, wasChange, dirs):
	if last[square] == free and all(True if last[square+delta] != full else False for delta in dirs):
		return True, full  
	elif last[square] == full and sum(1 for delta in dirs if last[square+delta] == full) >= 4:
		return True, free

	return wasChange, last[square]

def star2(last, square, wasChange, dirs):
	numFulls = 0
	for delta in dirs:
		currentSquare = square + delta 
		while last[currentSquare] == floor and 1 <= currentSquare & 127 <= lastCol and 1 <= currentSquare >> 7 <= lastRow:
			currentSquare += delta
		if last[currentSquare] == full:
			numFulls += 1

	if last[square] == free and numFulls == 0:
		return True, full 
	elif last[square] == full and numFulls >= 5:
		return True, free

	return wasChange, last[square]

def star(inp, option, dirs):
	opt = star1 if option == 1 else star2
	res = inp[:]
	wasChange = True
	while wasChange:
		wasChange = False
		last = res[:]
		for square in nonFloor:
			wasChange, res[square] = opt(last, square, wasChange, dirs)

	return sum(1 for c in res if c == full)

free, full, floor = 0, 1, 2
toNumbers = {'L' : free, '.' : floor}

with open("input11.txt") as f:
	inp = [[floor]*128] + [[floor] + list(map(lambda x: toNumbers[x], row)) + [floor]*30 for row in f.read().splitlines()] + [[floor]*128]

lastRow = len(inp) - 2
lastCol = 98
inp = [col for row in inp for col in row]
nonFloor = [index for index, c in enumerate(inp) if c == free]
dirs = [128, -128, 127, -127, 129, -129, 1, -1]

print("Star 1:", star(inp, 1, dirs))
print("Star 2:", star(inp, 2, dirs))