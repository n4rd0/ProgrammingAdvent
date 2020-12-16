import re
from functools import reduce
from operator import mul 

def parse_input():
	with open("input16.txt") as f:
		inp = f.read().split('\n\n')

	fields = re.findall(r"(.+): (\d+-\d+) or (\d+-\d+)", inp[0])
	fields = {name : parse_fields([fst_range, sec_range]) for name, fst_range, sec_range in fields}
	
	your_ticket = inp[1].split('\n')[1]
	your_ticket = list(map(int, your_ticket.split(',')))

	nearby_tickets = re.findall(r"([\d,]+)", inp[-1])
	nearby_tickets = [list(map(int, ticket.split(','))) for ticket in nearby_tickets]

	return fields, your_ticket, nearby_tickets


def parse_fields(ranges):
	return [tuple(map(int, rang.split('-'))) for rang in ranges]


def star_1(fields, nearby_tickets):
	return sum(filter(is_field_invalid, [field for ticket in nearby_tickets for field in ticket]))


def star_2(fields, your_ticket, nearby_tickets):
	fields_range = range(len(fields))

	valid_nearby_tickets = list(filter(is_ticket_valid, nearby_tickets))
	field_possible_columns = [list(fields_range) for i in fields_range] 

	for i, ranges in enumerate(fields.values()):
		for j in fields_range:
			if not is_column_valid(j, ranges, valid_nearby_tickets):
				field_possible_columns[i].remove(j)
			
	field_column = get_correspondence(field_possible_columns)

	departure_fields = [i for i, field in enumerate(fields) if field.startswith("departure")]
	return reduce(mul, [your_ticket[field_column[num_field]] for num_field in departure_fields])


def is_field_invalid(field):
	return not any(lowest <= field <= highest for atr in fields.values() for (lowest, highest) in atr)


def is_ticket_valid(ticket):
	return not any(is_field_invalid(field) for field in ticket)


def is_column_valid(column, ranges, valid_nearby_tickets):
	for ticket in valid_nearby_tickets:
		if not any(lowest <= ticket[column] <= highest for (lowest, highest) in ranges):
			return False

	return True


# Returns a one to one correspondence between fields and columns from a ticket
def get_correspondence(field_possible_columns):
	wasChange = True 

	while wasChange:
		wasChange = False

		for j, field in enumerate(field_possible_columns):
			if len(field) == 1:
				for i in range(len(fields)):
					if i != j and field[0] in field_possible_columns[i]:
						wasChange = True
						field_possible_columns[i].remove(field[0])

	return [field_column[0] for field_column in field_possible_columns]


fields, your_ticket, nearby_tickets = parse_input()

print("Star 1:", star_1(fields, nearby_tickets))
print("Star 2:", star_2(fields, your_ticket, nearby_tickets))
