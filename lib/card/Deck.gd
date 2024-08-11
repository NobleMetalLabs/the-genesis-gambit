class_name Deck
extends Serializeable

var _cards : Array[CardMetadata] = []
var leader : CardMetadata

func add_card(card : CardMetadata) -> void:
	_cards.append(card)

func remove_card(card : CardMetadata) -> void:
	_cards.erase(card)

func get_cards() -> Array[CardMetadata]:
	return _cards

func _to_string() -> String:
	return "Deck(<%s>[%s])" % [leader, _cards]

static func prebuilt_from_tribe(tribe : Genesis.CardTribe) -> Deck:
	var deck := Deck.new()
	for card in CardDB.get_cards_by_tribe(tribe):
		deck.add_card(card)
		if card.type == Genesis.CardType.LEADER:
			deck.leader = card
	if tribe == Genesis.CardTribe.BUGS:
		deck.remove_card(CardDB.get_card_by_id(CardDB.get_id_by_name("Fungus Garden")))
	return deck

static var EMPTY := Deck.new()