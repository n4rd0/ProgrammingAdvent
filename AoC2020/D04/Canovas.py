import re

def bothStars(list_passports,necessary_data,parameters):
	valid_passports_1 = 0
	valid_passports_2 = 0

	for passport in list_passports:
		if all(data in passport for data in necessary_data):
			valid_passports_1 += 1

			correct_parameters = True
			for data in necessary_data:
				value = re.search("(?<="+data+":)\\S+",passport).group()
				correct_parameters = parameters[data](value)

				if not correct_parameters:
					break

			if correct_parameters:
				valid_passports_2 += 1

	return valid_passports_1,valid_passports_2


necessary_data = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

parameters = {
	"byr" : lambda x : 1920 <= int(x) <= 2002 ,
	"iyr" : lambda x : 2010 <= int(x) <= 2020,
	"eyr" : lambda x : 2020 <= int(x) <= 2030,
	"hgt" : lambda x : bool(re.match(r"(1[5-8][0-9]|19[0-3])cm$|(59|6[0-9]|7[0-6])in$",x)),
	"hcl" : lambda x : bool(re.match(r"#[0-9a-f]{6}$",x)),
	"ecl" : lambda x : bool(re.match(r"(amb|blu|brn|gry|grn|hzl|oth)$",x)),
	"pid" : lambda x : bool(re.match(r"\d{9}$",x))
}

with open('input.txt') as file:
	input_list = file.read().split("\n\n")

print(bothStars(input_list,necessary_data,parameters))