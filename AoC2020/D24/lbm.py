import re
from collections import defaultdict

dirs = {"ne" : 1+2j, "nw" : -1+2j, "se" : 1-2j, "sw" : -1-2j, "e" : 2+0j, "w" : -2+0j}

        
def parse_input():
    with open("input24.txt") as f:
        inp = f.read().strip().splitlines()
    return [re.findall(r"w|e|ne|nw|se|sw", line) for line in inp]


def star_1(tiles, dirs):
    return sum(val for tile, val in tiles.items())


def star_2(tiles, dirs):
    is_tiles_2 = True
    tiles = [tiles.copy(), tiles.copy()]
    for _ in range(100):
        black_neighbours = num_black_neighbours(tiles[is_tiles_2], dirs)
        is_tiles_2 = not is_tiles_2
        for tile, num_blacks in black_neighbours.items():
            if tiles[not is_tiles_2][tile] and (num_blacks == 0 or num_blacks > 2):
                tiles[is_tiles_2][tile] = False
            elif not tiles[not is_tiles_2][tile] and num_blacks == 2:
                tiles[is_tiles_2][tile] = True
            else:
                tiles[is_tiles_2][tile] = tiles[not is_tiles_2][tile]

    return sum(tile for tile in tiles[is_tiles_2].values())


def set_initial_tiles(inp, dirs):
    tiles = defaultdict(lambda: False)

    for instr in inp:
        coord = 0+0j
        for direction in instr:
            coord += dirs[direction]
        tiles[coord] = not tiles[coord]
    
    return tiles


def num_black_neighbours(tiles, dirs):
    tile_to_blacks = defaultdict(lambda:0)
    for tile, is_black in tiles.items():
        tile_to_blacks[tile]
        if is_black:
            for direction in dirs.values():
                tile_to_blacks[tile+direction] += 1
    return tile_to_blacks
    

inp = parse_input()
tiles = set_initial_tiles(inp, dirs)
print("Star 1:", star_1(tiles, dirs))
print("Star 2:", star_2(tiles, dirs))
