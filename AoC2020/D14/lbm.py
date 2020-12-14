import re

def getInput():
	with open("input14.txt") as f:
		masks = []
		instrs = []
		
		for raw_line in f.read().splitlines():
			line_data = re.match(r"mem\[(\d+)\] = (\d+)", raw_line)

			if line_data != None:
				instrs[-1].append((int(line_data.group(1)), int(line_data.group(2))))
			else:
				line_data = re.match(r"mask = ([X10]{36})", raw_line)
				masks.append(line_data.group(1))
				instrs.append([])

	return list(zip(masks, instrs))


def star_1(masks_and_instrs):
	dirs = dict()

	for (mask, instrs) in masks_and_instrs:
		orMask = default_X(mask, '0')
		andMask = default_X(mask, '1')

		for (direction, value) in instrs:
			dirs[direction] = value & andMask | orMask

	return sum(dirs.values())


def star_2(masks_and_instrs):
	dirs = dict()

	for (mask, instrs) in masks_and_instrs:
		for (original_direction, value) in instrs:
			for new_direction in get_all_directions(original_direction, mask):
				dirs[new_direction] = value

	return sum(dirs.values())


def default_X(mask, default_value):
	return int(''.join([digit if digit != 'X' else default_value for digit in mask]), 2)


def get_all_directions(non_floating_dir, mask):
	direction = bin(non_floating_dir)[2:]
	direction = '0' * (len(mask) - len(direction)) + direction
	to_floating = ''.join([parse(pair) for pair in zip(direction, mask)])
	return unfloat(to_floating, to_floating.count('X'))


def parse(pair):
	binary_digit, mask_char = pair
	if mask_char in ['X', '1']:
		return mask_char
	else:
		return binary_digit


def unfloat(floating_dir, num_X):
	if num_X == 0:
		return [int(floating_dir, 2)]

	return unfloat(floating_dir.replace('X', '0', 1), num_X-1) + unfloat(floating_dir.replace('X', '1', 1), num_X-1) 


masks_and_instrs = getInput()

print("Star 1:", star_1(masks_and_instrs))
print("Star 2:", star_2(masks_and_instrs))	