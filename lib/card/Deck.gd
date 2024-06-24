class_name Deck
extends Resource

var _cards : Array[CardInDeck]

func _init() -> void:
	_cards = []

func add_card(card : CardInDeck) -> void:
	_cards.append(card)

func insert_card(card : CardInDeck, index : int) -> void:
	_cards.insert(index, card)

func remove_card(card : CardInDeck) -> void:
	_cards.erase(card)

func draw_card() -> CardInDeck:
	if _cards.size() == 0:
		return null
	return _cards.pop_front()

func get_cards() -> Array[CardInDeck]:
	return _cards

func shuffle() -> void:
	randomize()
	_cards.shuffle()