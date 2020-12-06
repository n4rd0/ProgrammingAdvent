with open("input6.txt") as f:
	inp = f.read().strip('\n').split('\n\n')

print("Star 1:", sum(len(set(group.replace('\n', ''))) for group in inp))
print("Star 2:", sum(len(set.intersection(*[set(person) for person in group.split('\n')])) for group in inp))