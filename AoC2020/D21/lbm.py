def parse_input():
	with open("input21.txt") as f:
		inp = f.read().strip().splitlines()
		inp = [food[:-1].split(' (contains ') for food in inp]
		inp = [[food[0].split(' '), food[1].split(', ')] for food in inp]

	return inp


def star_1(allerg_to_ingr):
	return sum(1 for ingr in [ingr for food, allergen in inp for ingr in food] if ingr not in allerg_to_ingr)


def star_2(allerg_to_ingr):
	return ','.join(sorted(list(allerg_to_ingr), key = lambda x: allerg_to_ingr[x]))


def allerg_ingr_correspondence(inp):
	allergs = set([allergen for food in inp for allergen in food[1]])
	
	allergens_to_ingrs = {allergen : [] for allergen in allergs}

	for food, alls in inp:
		for allergen in alls:
			allergens_to_ingrs[allergen].append(set(food))

	allergen_to_poss_ingrs = {allergen : {} for allergen in allergens_to_ingrs}

	for allergen, foods in allergens_to_ingrs.items():
		allergen_to_poss_ingrs[allergen] = set.intersection(*foods)

	
	while any(len(poss)!=1 for poss in allergen_to_poss_ingrs.values()):
		for allergen, poss in allergen_to_poss_ingrs.items():
			if len(poss) == 1:
				ingr = list(poss)[0]
				allergen_to_poss_ingrs[allergen] = poss

				for allergen_2, poss_2 in allergen_to_poss_ingrs.items():
					if allergen_2 != allergen and ingr in poss_2:
						allergen_to_poss_ingrs[allergen_2].remove(ingr)

	return {el : allerg  for allerg, ingr in allergen_to_poss_ingrs.items() for el in ingr}


inp = parse_input()
allerg_to_ingr = allerg_ingr_correspondence(inp)

print("Star 1:", star_1(allerg_to_ingr))
print("Star 2:", star_2(allerg_to_ingr))