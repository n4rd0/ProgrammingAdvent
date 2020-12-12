cardinalToComplexDirection = {'N': 0 + 1j, 'E': 1 + 0j, 'S': 0 - 1j, 'W': -1 + 0j}

def getInputInstructions(path):

	with open(path) as f:

		instructions = []

		for rawInstruction in f.read().splitlines():

			# Input lines are a character followed by a number
			# e.g. F40

			direction = rawInstruction[0]
			amount = int(rawInstruction[1:])

			instructions.append((direction, amount))

	return instructions



def getManhattanDistanceAfterInstructions(instructions):
	# Ship 1 is star 1, ship 2 is star 2
	ship1Position = ship2Position = 0 + 0j

	orientationShip1 = 1 + 0j

	wayPointLocationRelativeToShip2 = 10 + 1j

	for (instruction, amount) in instructions:

		if instruction == 'L' or instruction == 'R':
			
			orientationShip1 *= getRotation(instruction, amount)
			wayPointLocationRelativeToShip2 *= getRotation(instruction, amount)

		elif instruction == 'F':

			ship1Position += stepToMoveFromComplexDirection(orientationShip1, amount)
			ship2Position += stepToMoveFromComplexDirection(wayPointLocationRelativeToShip2, amount)

		# N, E, S, W
		else:

			ship1Position += stepToMoveFromCardinalDirection(instruction, amount)
			wayPointLocationRelativeToShip2 += stepToMoveFromCardinalDirection(instruction, amount)


	ship1ManhattanDistance = manhattanDistanceFromComplexNumber(ship1Position)
	ship2ManhattanDistance = manhattanDistanceFromComplexNumber(ship2Position)

	return ship1ManhattanDistance, ship2ManhattanDistance



def stepToMoveFromCardinalDirection(direction, amount):

	return amount * cardinalToComplexDirection[direction]


def stepToMoveFromComplexDirection(direction, amount):

	return amount * direction


def getRotation(rotationDirection, degrees):

	# Sign that will come with i
	# Product by i is 90 degrees counterclockwise ('left')
	# Product by -i is 90 degrees clockwise ('right')

	rotationSign = 1 if rotationDirection == 'L' else -1

	multipleOf90 = degrees // 90

	return (rotationSign * 1j) ** multipleOf90
	

def manhattanDistanceFromComplexNumber(cmplx):
	return int( abs(cmplx.real) + abs(cmplx.imag) )



ship1ManhattanDistance, ship2ManhattanDistance = getManhattanDistanceAfterInstructions(getInputInstructions("input12.txt"))

print("Star 1:", ship1ManhattanDistance)
print("Star 2:", ship2ManhattanDistance)