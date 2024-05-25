class_name Player
extends Control

var deck : Deck
var hand : Array[CardMetadata] = []

func _ready() -> void:
	deck = Deck.new()
	for i in range(0, 25):
		var card_instance := ICardInstance.new(
			CardDB.cards.pick_random()
		)
		deck.add_card(card_instance)
	deck.shuffle()

	AuthoritySourceProvider.authority_source.reflect_action.connect(_handle_player_action)

func _handle_player_action(action : Action) -> void:
	if not action is PlayerAction: return

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

	UIEventBus.submit_event({
		"name" : "player_hand_changed",
		"player" : self,
	})
