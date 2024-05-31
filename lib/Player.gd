class_name Player
extends Object

var deck : Deck 
var cards_in_hand : Array[CardInHand] = []
var cards_on_field : Array[CardOnField] = []

func _init() -> void:
	deck = Deck.new()
	for i in range(0, 1):
		var card_instance := ICardInstance.new(
			CardDB.cards.pick_random(),
			self
		)
		deck.add_card(card_instance)
	deck.shuffle()

	#AuthoritySourceProvider.authority_source.reflect_action.connect(_handle_action)

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
				var drawn_card : ICardInstance = deck.draw_card()
				if drawn_card == null: 
					push_warning("Somehow deck has no cards.")
					return 
				var card_in_hand : CardInHand = CardInHand.new([drawn_card])
				cards_in_hand.append(card_in_hand)
				
			[false, true]: # Spawn New Card
				# var card_meta : CardMetadata = CardDB.get_card_by_id(add_action.card_metadata_id)
				# hand.append(card_meta)
				# TODO: fix
				pass # BRO I DO NOT FUCKING CARE
			[true, true]: # Search
				pass
			[false, false]: 
				print("Invalid HandAddCardAction")
				#TODO: Give a totally random card?

	if action is HandBurnHandAction:
		var num_cards : int = cards_in_hand.size()
		cards_in_hand.clear()
		#TODO: clearing hand occurs through action
		# ^ bro what why. show your mf work dog.
		for i in range(num_cards):
			AuthoritySourceProvider.authority_source.request_action(
				HandAddCardAction.new(self, false, true, 0)
			)

	if action is HandRemoveCardAction:
		var remove_action : HandRemoveCardAction = action as HandRemoveCardAction
		cards_in_hand.erase(remove_action.card)

	UIEventBus.submit_action(
		CustomAction.new(
			"player_hand_changed",
			{
				"player" : self
			}
	))
