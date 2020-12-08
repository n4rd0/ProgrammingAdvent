import re

def parseInp(inp):
	bagTypes = re.findall(r"(.+?)(?= bags contain)",inp)
	bagsInside = [dict(map(lambda p:(p[1], int(p[0])), re.findall(r"(\d+) (.+?) bags?[,.]", bagType))) \
					for bagType in inp.splitlines()]
	return dict(zip(bagTypes, bagsInside))

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
	bags = parseInp(f.read())

print("Star 1:", star1(bags, list(bags)))
print("Star 2:", star2(bags, "shiny gold", list(bags["shiny gold"])))	