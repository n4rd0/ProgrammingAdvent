toBinary = {'B':'1', 'F':'0', 'R':'1', 'L':'0'}

with open("input5.txt") as f:
	inp = [int("".join([toBinary[c] for c in line]), 2) for line in f.read().splitlines()]

print("Star 1:", max(inp))
print("Star 2:", sum(range(min(inp), max(inp)+1)) - sum(inp))