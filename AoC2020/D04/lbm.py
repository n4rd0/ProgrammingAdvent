import re

def parseInput(inp):
	inp = inp.strip('\n').split("\n\n")
	inp = [re.split(r"[\s\n]", passport) for passport in inp]
	inp = [dict([spec.split(':') for spec in passport]) for passport in inp]

	for passport in inp:
		passport.pop("cid", None)
		for spec in ["byr", "iyr", "eyr"]:
			if spec in passport:
				passport[spec] = int(passport[spec])

	return inp

def stars(inp):
	star1, star2 = 0, 0
	
	for passport in inp:
		if len(passport) < 7:
			continue
		else:
			star1 += 1
			isValid = True
			for spec in passport:
				if checkInvalid[spec](passport[spec]):
					isValid = False
					break
			if isValid:
				star2 += 1

	return (star1, star2)

def isHgtInvalid(val):
	if re.search(r"^[0-9]+(cm|in)$",val) == None:
		return True

	height, units = int(val[:-2]), val[-2:]
	return ( units == "cm" and (height < 150 or height > 193) ) or ( units == "in" and (height < 59 or height > 76) )

checkInvalid = {
	"byr" : lambda val: val < 1920 or val > 2002,
	"iyr" : lambda val: val < 2010 or val > 2020,
	"eyr" : lambda val: val < 2020 or val > 2030,
	"hcl" : lambda val: re.search(r"^#[0-9a-f]{6}$", val) == None,
	"ecl" : lambda val: re.search(r"^(amb|blu|brn|gry|grn|hzl|oth)$", val) == None,
	"pid" : lambda val: re.search(r"^[0-9]{9}$", val) == None,
	"hgt" : isHgtInvalid
}

with open("input4.txt") as f:
	inp = parseInput(f.read())

(star1, star2) = stars(inp)
print("Star 1:", star1)
print("Star 2:", star2)