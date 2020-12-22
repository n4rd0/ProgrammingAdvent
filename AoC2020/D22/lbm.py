def parse_input():
	with open("input22.txt") as f:
		decks = [list(map(int, player.split('\n')[1:])) for player in f.read().strip().split('\n\n')]
	
	return decks


def star_1(cards):
	while cards[0] and cards[1]:
		player_1_card = cards[0][0]
		player_2_card = cards[1][0]
		cards = update_cards(cards, player_2_card > player_1_card, player_1_card, player_2_card)

	winner_cards = cards[bool(cards[1])]
	return cards_value(winner_cards, len(winner_cards))


def star_2(cards):
	_, winner_cards = get_winner_cards(cards, set(), set())
	return cards_value(winner_cards, len(winner_cards))


def cards_value(winner_cards, num_cards):
	return sum(card*value for card, value in zip(winner_cards, range(num_cards, 0, -1)))


def get_winner_cards(cards, p1_prev_configs, p2_prev_configs):
	while cards[0] and cards[1]:
		player_1_card = cards[0][0]
		player_2_card = cards[1][0]

		if player_1_card + 1 <= len(cards[0]) and player_2_card + 1 <= len(cards[1]):
			new_cards = [cards[0][1:player_1_card+1], cards[1][1:player_2_card+1]]
			is_player_2_winner, _ = get_winner_cards(new_cards, set(), set())
			cards = update_cards(cards, is_player_2_winner, player_1_card, player_2_card)
		else:
			cards = update_cards(cards, player_2_card > player_1_card, player_1_card, player_2_card)

		if tuple(cards[0]) in p1_prev_configs or tuple(cards[1]) in p2_prev_configs:
			return False, cards[0]

		p1_prev_configs.add(tuple(cards[0]))
		p2_prev_configs.add(tuple(cards[1]))

	is_player_2_winner = bool(cards[1])
	return is_player_2_winner, cards[is_player_2_winner]


def update_cards(cards, is_2_winner, player_1_card, player_2_card):
	if not is_2_winner:
		return [cards[0][1:] + [player_1_card, player_2_card], cards[1][1:]]
	else:
		return [cards[0][1:], cards[1][1:] + [player_2_card, player_1_card]]


decks = parse_input()
print("Star 1:", star_1(decks))
print("Star 2:", star_2(decks))

