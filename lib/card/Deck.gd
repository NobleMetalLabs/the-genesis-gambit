class_name Deck
extends Resource

var _cards : Array[CardMetadata]
var leader : CardMetadata

func _init() -> void:
	_cards = []

func add_card(card : CardMetadata) -> void:
	_cards.append(card)

func remove_card(card : CardMetadata) -> void:
	_cards.erase(card)

func get_cards() -> Array[CardMetadata]:
	return _cards

static func prebuilt_from_tribe(tribe : Genesis.CardTribe) -> Deck:
	var deck := Deck.new()
	for card in CardDB.get_cards_by_tribe(tribe):
		deck.add_card(card)
		if card.type == Genesis.CardType.LEADER:
			deck.leader = card
	return deck

static var EMPTY := Deck.new()