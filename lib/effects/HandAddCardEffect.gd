class_name HandAddCardEffect
extends HandEffect

var from_deck : bool
var specific_card : bool
var card_metadata_id : int

func _init(_requester : Object, _player : Player, _from_deck : bool = true, _specific_card : bool = false, _card_metadata_id : int = 0) -> void:
	self.requester = _requester
	self.player = _player
	self.from_deck = _from_deck
	self.specific_card = _specific_card
	self.card_metadata_id = _card_metadata_id

func _to_string() -> String:
	return "HandAddCardEffect(%s,%s,%s,%s)" % [self.player, self.from_deck, self.specific_card, self.card_metadata_id]

func resolve(_effect_resolver : EffectResolver) -> void:
	match [self.from_deck, self.specific_card]:
		[true, false]: # Regular Draw
			var drawn_card : CardInDeck = self.player.cards_in_deck.pop_front()
			if drawn_card == null: 
				push_warning("Deck has no cards. Did you run out?")
				return 
			var card_in_hand : CardInHand = CardInHand.new([
				ICardInstance.id(drawn_card), 
				IStatisticPossessor.id(drawn_card), 
				IMoodPossessor.id(drawn_card),
			])
			self.player.cards_in_hand.append(card_in_hand)
			IStatisticPossessor.id(card_in_hand).set_statistic(Genesis.Statistic.IS_IN_DECK, false)
			IStatisticPossessor.id(card_in_hand).set_statistic(Genesis.Statistic.IS_IN_HAND, true)
			
		[false, true]: # Spawn New Card
			# var card_meta : CardMetadata = CardDB.get_card_by_id(self.card_metadata_id)
			# hand.append(card_meta)
			pass
		[true, true]: # Search
			pass
		[false, false]: 
			push_error("Invalid HandAddCardEffect")
	Router.client_ui.refresh_hand_ui()