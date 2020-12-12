from functools import reduce

def updateShips(acc, x):
	instr, val = x
	ship1, ship2, currentOrientation, wayPoint = acc
	if instr == 'N' or instr == 'E' or instr == 'S' or instr == 'W':
		move = val * dirs[instr]
		ship1, wayPoint = ship1 + move, wayPoint + move
	elif instr == 'F':
		ship1, ship2 = ship1 + val * currentOrientation, ship2 + val * wayPoint
	else:
		direction = 1 if instr == 'L' else -1
		rotation = (direction*1j)**val
		currentOrientation, wayPoint = currentOrientation * rotation, wayPoint * rotation
		
	return [ship1, ship2, currentOrientation, wayPoint]
	
with open("input12.txt") as f:
	inp = [(instr[0], int(instr[1:]) if instr[0]!='L' and instr[0]!='R' else int(instr[1:])//90) for instr in f.read().splitlines()]

dirs = {'N': 0 + 1j, 'E': 1 + 0j, 'S': 0 - 1j, 'W': -1 + 0j}
ship1, ship2, _, _ = reduce(updateShips, inp, [0+0j, 0+0j, 1+0j, 10+1j])
print("Star 1:", int(abs(ship1.real)+abs(ship1.imag)))
print("Star 2:", int(abs(ship2.real)+abs(ship2.imag)))