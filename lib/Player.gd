class_name Player
extends Control

var deck : Deck
var hand : Array[CardMetadata] = []
var cards_in_hand : Array[CardInHand] = []
var cards_on_field : Array[CardOnField] = []

func _ready() -> void:
	deck = Deck.new()
	for i in range(0, 25):
		var card_instance := ICardInstance.new(
			CardDB.cards.pick_random()
		)
		deck.add_card(card_instance)
	deck.shuffle()

	AuthoritySourceProvider.authority_source.reflect_action.connect(_handle_action)

func _handle_action(action : Action) -> void:
	if action is GamefieldAction: _handle_gamefield_action(action as GamefieldAction)
	if action is PlayerAction: _handle_player_action(action as PlayerAction)

func _handle_gamefield_action(action : GamefieldAction) -> void:
	if action is CreatureSpawnAction:
		var spawn_action := action as CreatureSpawnAction
		cards_on_field.append(spawn_action.creature)
	if action is CreatureLeavePlayAction:
		var leave_action := action as CreatureLeavePlayAction
		cards_on_field.erase(leave_action.creature)
	UIEventBus.submit_action(action)

func _handle_player_action(action : PlayerAction) -> void:
	if action is HandAction:
		_handle_hand_action(action as HandAction)
	if action is CursorAction:
		UIEventBus.submit_action(action)

func _handle_hand_action(action : HandAction) -> void:
	if action is HandAddCardAction:
		var add_action : HandAddCardAction = action as HandAddCardAction
		match [add_action.from_deck, add_action.specific_card]:
			[true, false]: # Regular Draw
				var card : ICardInstance = deck.draw_card()
				if card == null: return #TODO: Actually handle this
				hand.append(card.metadata)
			[false, true]: # Spawn New Card
				var card_meta : CardMetadata = CardDB.get_card_by_id(add_action.card_metadata_id)
				hand.append(card_meta)
			[true, true]: # Search
				pass
			[false, false]: 
				print("Invalid HandAddCardAction")
				#TODO: Give a totally random card?

	if action is HandBurnHandAction:
		var num_cards : int = hand.size()
		hand.clear()
		#TODO: clearing hand occurs through action
		for i in range(num_cards):
			AuthoritySourceProvider.authority_source.request_action(
				HandAddCardAction.new(self, false, true, 0)
			)

	if action is HandRemoveCardAction:
		var remove_action : HandRemoveCardAction = action as HandRemoveCardAction
		hand.erase(remove_action.card.metadata)

	UIEventBus.submit_action(
		CustomAction.new(
			"player_hand_changed",
			{
				"player" : self
			}
	))
