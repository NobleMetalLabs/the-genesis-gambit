class_name BackendObjectCollection
extends Resource

var players : Array[Player] = []
var cards : Array[ICardInstance] = []

func _init(_players : Array[Player]) -> void:
	for p : Player in _players:
		cards += p.cards_in_hand + p.cards_on_field + p.cards_in_deck
		players.append(p)

