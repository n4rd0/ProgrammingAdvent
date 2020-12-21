
def firstStar(map, x, y):
	nTrees = 0
	column = 0
	wide = len(map[0])-1

	for row in map[y::y]:
		column += x
		if(row[column % wide] == "#"):
			nTrees += 1

	return nTrees


def secondStar(map, slopes):
	result = 1
	for slope in slopes:
		result *= firstStar(map,slope[0],slope[1])

	return result


with open('input.txt') as file:
	input_list = file.readlines()

slopes = [[1,1], [3,1], [5,1], [7,1], [1,2]]

print(firstStar(input_list,3,1))
print(secondStar(input_list,slopes))