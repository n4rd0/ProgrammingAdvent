import copy

def star1(inp, nonFloorSquares, dirs):
	res = copy.deepcopy(inp)
	wasChange = True
	while wasChange:
		wasChange = False
		last = copy.deepcopy(res)
		for nonFloorSq in nonFloorSquares:
			row, col = nonFloorSq[0], nonFloorSq[1]
			square = last[row][col]
			if square == free and all(True if not last[row+delta[1]][col+delta[0]] == full else False for delta in dirs):
				wasChange = True
				res[row][col] = full
			elif square == full and sum(1 for delta in dirs if last[row+delta[1]][col+delta[0]] == full) >= 4:
				wasChange = True
				res[row][col] = free

	return sum(1 for row in res[1:-1] for col in row[1:-1] if col == full)


def star2(inp, nonFloorSquares, dirs):
	res = copy.deepcopy(inp)
	wasChange = True
	while wasChange:
		wasChange = False
		last = copy.deepcopy(res)
		for nonFloorSq in nonFloorSquares:
			row, col = nonFloorSq[0], nonFloorSq[1]
			square = last[row][col]
			numFull = search(last, row, col, dirs)
			if square == free and numFull == 0:
				wasChange = True
				res[row][col] = full
			elif square == full and numFull >= 5:
				wasChange = True
				res[row][col] = free

	return sum(1 for row in res[1:-1] for col in row[1:-1] if col == full)

def search(inp, rowStart, colStart, dirs):
	counter = 0
	for delta in dirs:
		lastRow, lastCol = rowStart+delta[1], colStart+delta[0]
		while inp[lastRow][lastCol] == floor and 1 <= lastRow <= rows and 1 <= lastCol <= cols:
			lastRow, lastCol = lastRow+delta[1], lastCol+delta[0]
		if inp[lastRow][lastCol] == full:
			counter += 1 

	return counter	


free, full, floor = 0, 1, 2
toNumbers = {'.': floor, 'L': free}
nonFloor = []

with open("input11.txt") as f:
	text = f.read().splitlines()
	rows, cols = len(text), len(text[0])
	inp = [[floor]*(cols+2)]
	for indexRow, row in enumerate(text, 1):
		inp.append([floor])
		for indexCol, col in enumerate(row, 1):
			colValue = toNumbers[col]
			inp[indexRow].append(colValue)
			if colValue != floor:
				nonFloor.append((indexRow, indexCol))
		inp[indexRow].append(floor)

	inp.append([floor]*(cols+2))

dirs = [(1,0), (-1,0), (0,1), (0,-1), (1,1), (1,-1), (-1, 1), (-1,-1)]
print("Star 1:",star1(inp, nonFloor, dirs))
print("Star 2:",star2(inp, nonFloor, dirs))