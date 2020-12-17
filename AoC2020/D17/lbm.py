from itertools import product
from collections import defaultdict
from copy import copy
from operator import add

ITERATIONS = 6


def parse_input():
	with open("input17.txt") as f:
		inp = f.read().splitlines()

	return [(i, j) for i, row in enumerate(inp) for j, col in enumerate(row) if col == '#']


def num_actives_after_iters(dimensions, iterations, initial_actives):
	grids, dirs = get_initial_data(dimensions, initial_actives)
	one_grid = True

	for i in range(iterations):
		one_grid = not one_grid
		num_neighbours = cube_to_num_neighbours(grids[not one_grid], dirs, dimensions)
		grids[one_grid] = defaultdict(lambda: False)
		
		for cube in num_neighbours:
			if becomes_active(cube, grids[not one_grid], num_neighbours):
				grids[one_grid][cube] = True

	return sum(grids[one_grid].values())


# Expands input to required dimensions
def get_initial_data(dimensions, initial_actives):
	dirs = list(product(*([range(-1, 2)] * dimensions)))
	dirs.remove((0,) * dimensions)

	grid = defaultdict(lambda: False)
	for (x, y) in initial_actives:
		grid[(x, y) + (0,) * (dimensions - 2)] = True

	return [copy(grid), copy(grid)], dirs	


def becomes_active(cube, last_grid, num_neighbours):
	num_active = num_neighbours[cube]
	return last_grid[cube] and num_active in [2,3] or not last_grid[cube] and num_active == 3


# Returns dict cube_coords : number_of_active_neighbours
# Cubes with 0 active neighours not included
def cube_to_num_neighbours(grid, dirs, dimensions):
	grid_num_neighbours = defaultdict(lambda: 0)
	for cube in grid:
		for delta in dirs:
			grid_num_neighbours[tuple(map(add, cube, delta))] += 1

	return grid_num_neighbours


initial_actives = parse_input()

print("Star 1:", num_actives_after_iters(3, ITERATIONS, initial_actives))
print("Star 2:", num_actives_after_iters(4, ITERATIONS, initial_actives))