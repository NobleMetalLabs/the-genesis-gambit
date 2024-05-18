class_name Deck
extends Resource

var _cards : Array[ICardInstance]

func _init() -> void:
	_cards = []

func add_card(card : ICardInstance) -> void:
	_cards.append(card)

func remove_card(card : ICardInstance) -> void:
	_cards.erase(card)

func draw_card() -> ICardInstance:
	if _cards.size() == 0:
		return null
	return _cards.pop_front()

func get_cards() -> Array[ICardInstance]:
	return _cards

func shuffle() -> void:
	randomize()
	_cards.shuffle()