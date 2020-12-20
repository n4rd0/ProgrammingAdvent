import re
import numpy as np
from copy import copy
from functools import reduce
from operator import mul
import time

up, down, right, left = 0, 1, 2, 3

sides = {
	up : lambda mat: mat[0,:],
	down : lambda mat: mat[len(mat)-1,:],
	right : lambda mat: mat[:,len(mat)-1],
	left : lambda mat: mat[:,0]
}

opposite = {up:down, down:up, left:right, right:left}


def parse_input():
	with open("input20.txt") as f:
		inp = f.read().strip().split('\n\n')
		inp = [mat.split('\n') for mat in inp]

	tiles = dict()
	for mat in inp:
		tile = int(re.match(r"Tile (\d+):", mat[0]).group(1))
		parsed_mat = np.array([[1 if col == '#' else 0 for col in row] for row in mat[1:]])
		tiles[tile] = parsed_mat

	return tiles


def possible_bounds_and_arrangements(tiles):
	possible_bounds = dict()
	arrangements = dict()

	for tile, mat in tiles.items():
		possible_bounds[tile] = possible_boundaries(mat)
		arrangements[tile] = possible_arrangements(mat)

	return possible_bounds, arrangements


def star_1(tile_to_neighbours):
	return reduce(mul, [tile for tile, neighs in tile_to_neighbours.items() if len(neighs) == 2])


def star_2(tiles, tile_to_neighbours):
	correct_orientation, correct_neighbours = correct_orientation_and_neighbours(tiles, tile_to_neighbours)
	image = pack_tiles(correct_orientation, correct_neighbours)

	monster = [
		"                  # ", 
		"#    ##    ##    ###", 
		" #  #  #  #  #  #   "
	]

	lastY = len(monster)-1
	lastX = len(monster[0])-1
	monster = [(dy, dx) for dy, row in enumerate(monster) for dx, col in enumerate(row) if col == '#'] 

	for mat in possible_arrangements(image):
		counter = 0
		for i in range(len(mat)-lastY):
			for j in range(len(mat)-lastX):
				if all(mat[i+dy, j+dx]==1 for dy, dx in monster):
					counter += 1
					
		if counter > 0:
			break

	return sum(1 for row in image for col in row if col==1) - counter*len(monster)


def correct_orientation_and_neighbours(tiles, tile_to_neighbours):
	tiles_list = list(tiles)
	size = len(tiles_list)
	correct_neighbours = {tile: {up: 0, down: 0, right: 0, left: 0} for tile in tiles}
	correct_orientation = {tiles_list[0] : tiles[tiles_list[0]]}

	these_neighbours = [tiles_list[0]]

	empty = 0
	while empty < size:
		next_neighbours = set([m for neigh in these_neighbours for m in tile_to_neighbours[neigh] if tile_to_neighbours[m]])

		for m in these_neighbours:
			curr_mat = correct_orientation[m]

			for delta, get_side_array in sides.items():
				found = False
				side_array = get_side_array(curr_mat)
				opposite_side = sides[opposite[delta]]

				for neighbour in tile_to_neighbours[m]:
					if neighbour in correct_orientation:
						if (side_array == opposite_side(correct_orientation[neighbour])).all():
							correct_neighbours[m][delta] = neighbour
							found = True
					else:
						for possible in arrangements[neighbour]:
							if (side_array == opposite_side(possible)).all():
								correct_neighbours[m][delta] = neighbour
								correct_orientation[neighbour] = possible
								found = True
								break
					if found:
						tile_to_neighbours[m].remove(neighbour)
						if not tile_to_neighbours[m]:
							empty += 1
						break

		these_neighbours = next_neighbours

	return correct_orientation, correct_neighbours


def pack_tiles(correct_orientation, correct_neighbours):
	correct_orientation = {tile : correct_orientation[tile][1:9,1:9] for tile in correct_orientation}
	leftmost = [tile for tile, neighs in correct_neighbours.items() if neighs[left] == 0 and neighs[up] == 0]

	current_tile = correct_neighbours[leftmost[0]][down]
	while current_tile != 0:
		leftmost.append(current_tile)
		current_tile = correct_neighbours[current_tile][down]

	row_stacked = []

	for tile in leftmost:
		row_tiles = [tile]
		current_tile = correct_neighbours[tile][right]
		while current_tile != 0:
			row_tiles.append(current_tile)
			current_tile = correct_neighbours[current_tile][right]

		row_stacked.append(np.hstack([correct_orientation[tile] for tile in row_tiles]))

	return np.vstack(row_stacked)


def rotate_90(mat):
	return np.array([mat[:,i] for i in range(len(mat)-1, -1, -1)])

def x_symmetry(mat):
	return np.array(list(reversed(mat)))

def y_symmetry(mat):
	return np.array([list(reversed(row)) for row in mat])

def transpose(mat):
	return np.transpose(copy(mat))

def anti_transpose(mat):
	rows, cols = mat.shape
	last_row, last_col = rows-1, cols-1
	for i in range(rows):
		for j in range(rows-i):
			mat[last_col-j, last_row-i], mat[i, j] = mat[i, j], mat[last_col-j, last_row-i]
	return mat


def possible_arrangements(mat):
	possible = [copy(mat), x_symmetry(mat), y_symmetry(mat), transpose(mat), anti_transpose(copy(mat))]
	current_rot = copy(mat)
	for i in range(3):
		current_rot = rotate_90(current_rot)
		possible.append(current_rot)

	return possible


def possible_boundaries(mat):
	possible = []
	for side, get_side in sides.items():
		array = get_side(mat)
		possible += [array, np.array(list(reversed(array)))]

	return possible


def can_match(boundsA, boundsB):
	return any((a==b).all() for a in boundsA for b in boundsB)


def get_tile_neighbours(tiles, possible_bounds):
	tile_to_neighbours = {t:[] for t in tiles}
	tiles = list(possible_bounds)
	size = len(possible_bounds)

	for i, tile_1 in enumerate(tiles[:-1]):
		tile_1_bounds = possible_bounds[tile_1]

		for tile_2 in tiles[i+1:]:
			if can_match(tile_1_bounds, possible_bounds[tile_2]):
				tile_to_neighbours[tile_1].append(tile_2)
				tile_to_neighbours[tile_2].append(tile_1)

	return tile_to_neighbours


tiles = parse_input()
possible_bounds, arrangements = possible_bounds_and_arrangements(tiles)
tile_to_neighbours = get_tile_neighbours(list(tiles), possible_bounds)

print("Star 1:", star_1(tile_to_neighbours))
print("Star 2:", star_2(tiles, tile_to_neighbours))