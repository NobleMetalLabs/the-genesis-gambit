class_name GameAccess

var card_processor : CardProcessor

func _init(_card_processor : CardProcessor) -> void:
	card_processor = _card_processor
	return

var object_collection : BackendObjectCollection
func update_object_collection(collection : BackendObjectCollection) -> void:
	object_collection = collection

func get_players_field(player : Player) -> Array[ICardInstance]:
	return []

func get_players_hand(player : Player) -> Array[ICardInstance]:
	return []

func get_players_deck(player : Player) -> Array[ICardInstance]:
	return []

func are_two_cards_friendly(card1 : ICardInstance, card2 : ICardInstance) -> bool:
	var cards : Array[ICardInstance] = []
	cards.assign([card1, card2])
	return _are_all_cards_friendly(cards)

func are_all_cards_friendly(cards : Array[ICardInstance]) -> bool:
	return _are_all_cards_friendly(cards)

func _are_all_cards_friendly(cards : Array[ICardInstance]) -> bool:
	for card in cards:
		if not are_two_cards_friendly(cards[0], card):
			return false
	return true
