class_name GameAccess
extends RefCounted

var card_processor : CardProcessor = CardProcessor.new()
var event_scheduler : EventScheduler : 
	get:
		return card_processor.event_scheduler

func _init() -> void:
	event_scheduler._register_bulk(
		[
			EventProcessingStep.new(
				AllCardsTargetGroup.new(), "ENTERED_DECK", self, HANDLE_ZONE_TRANSITION_EVENT_FOR_GAMEACCESS, 
				EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MIN)
			),
			EventProcessingStep.new(
				AllCardsTargetGroup.new(), "LEFT_DECK", self, HANDLE_ZONE_TRANSITION_EVENT_FOR_GAMEACCESS, 
				EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MIN)
			),
			EventProcessingStep.new(
				AllCardsTargetGroup.new(), "ENTERED_FIELD", self, HANDLE_ZONE_TRANSITION_EVENT_FOR_GAMEACCESS, 
				EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MIN)
			),
			EventProcessingStep.new(
				AllCardsTargetGroup.new(), "LEFT_FIELD", self, HANDLE_ZONE_TRANSITION_EVENT_FOR_GAMEACCESS, 
				EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MIN)
			),
			EventProcessingStep.new(
				AllCardsTargetGroup.new(), "ENTERED_HAND", self, HANDLE_ZONE_TRANSITION_EVENT_FOR_GAMEACCESS, 
				EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MIN)
			),
			EventProcessingStep.new(
				AllCardsTargetGroup.new(), "LEFT_HAND", self, HANDLE_ZONE_TRANSITION_EVENT_FOR_GAMEACCESS, 
				EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MIN)
			)
		]
	)
	return

func _to_string() -> String: return "GameAccess(%s)" % [card_processor]

func duplicate() -> GameAccess:
	var dupe : GameAccess = GameAccess.new()
	dupe.card_processor = card_processor.duplicate()
	dupe._cards = _cards.duplicate(true)
	return dupe

# var object_collection : BackendObjectCollection
# func update_object_collection(collection : BackendObjectCollection) -> void:
# 	object_collection = collection

var _cards : Array[ICardInstance] = []
var _player_decks : Dictionary = {} # [Player, Array[ICardInstance]]
var _player_fields : Dictionary = {} # [Player, Array[ICardInstance]]
var _player_hands : Dictionary = {} # [Player, Array[ICardInstance]]

func add_card(card : ICardInstance) -> void:
	_cards.append(card)

func get_players_field(player : Player) -> Array[ICardInstance]:
	return []

func get_players_hand(player : Player) -> Array[ICardInstance]:
	return []

func get_players_deck(player : Player) -> Array[ICardInstance]:
	return []

func are_two_cards_friendly(card1 : ICardInstance, card2 : ICardInstance) -> bool:
	return card1.player == card2.player

func are_all_cards_friendly(cards : Array[ICardInstance]) -> bool:
	for card in cards:
		if not are_two_cards_friendly(cards[0], card): # This is cap af
			return false
	return true

func HANDLE_ZONE_TRANSITION_EVENT_FOR_GAMEACCESS(event : Event) -> void:
	var card : ICardInstance = event.card
	var player_cards : Array[ICardInstance] = []
	if event is EnteredDeckEvent:
		_player_decks.get_or_add(card.player, player_cards).append(card)
	elif event is LeftDeckEvent:
		_player_decks.get_or_add(card.player, player_cards).erase(card)
	elif event is EnteredFieldEvent:
		_player_fields.get_or_add(card.player, player_cards).append(card)
	elif event is LeftFieldEvent:
		_player_fields.get_or_add(card.player, player_cards).erase(card)
	elif event is EnteredHandEvent:
		_player_hands.get_or_add(card.player, player_cards).append(card)
	elif event is LeftHandEvent:
		_player_hands.get_or_add(card.player, player_cards).erase(card)
	else:
		print("WARNING: Unhandled zone transition event %s." % [event])
