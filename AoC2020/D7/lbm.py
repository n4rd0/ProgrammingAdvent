import re

def parseInp(inp):
	inp = [re.split(r" bags contain | bag[s]{0,1}[,]{0,1}", bagType[:-1])[:-1] for bagType in inp]
	bags = dict()

	for bagType in inp:
		#e.g. ['muted aqua', '4 wavy bronze', ' 1 pale plum']
		outerBag = bagType[0]
		bags[outerBag] = dict()
		#e.g. ['clear olive', 'no other']
		if bagType[1][0] != 'n':
			bags[outerBag][bagType[1][2:]] = int(bagType[1][0])

		for bagsInside in bagType[2:]:
			bags[outerBag][bagsInside[3:]] = int(bagsInside[1])

	return bags

def star1(bags, entries):
	if not entries:
		return 0

	return checkShinyGold(bags, entries[0], list(bags[entries[0]])) + star1(bags, entries[1:])

def checkShinyGold(bags, currentBag, entries):
	if "shiny gold" in bags[currentBag]:
		return True

	if not (bags[currentBag] and entries):
		return False

	return 	checkShinyGold(bags, entries[0], list(bags[entries[0]])) or \
	checkShinyGold(bags, currentBag, entries[1:])

def star2(bags, currentBag, entries):
	if not (bags[currentBag] and entries):
		return 0

	return 	bags[currentBag][entries[0]] * (1 + star2(bags, entries[0], list(bags[entries[0]]))) + \
	star2(bags, currentBag, entries[1:])

with open("input7.txt") as f:
	bags = parseInp(f.read().splitlines())

print("Star 1:", star1(bags, list(bags)))
print("Star 2:", star2(bags, "shiny gold", list(bags["shiny gold"])))