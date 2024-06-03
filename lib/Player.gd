class_name Player
extends Node

var deck : Deck 
var cards_in_hand : Array[CardInHand] = []
var cards_on_field : Array[CardOnField] = []

var effect_resolver : EffectResolver

func _init(_effect_resolver : EffectResolver) -> void:
	deck = Deck.new()
	for i in range(0, 10):
		var card_instance := ICardInstance.new(
			CardDB.cards.pick_random(),
			self
		)
		var stats := IStatisticPossessor.new()
		stats.set_statistic(Genesis.Statistic.IS_IN_DECK, true)
		deck.add_card(CardInDeck.new([card_instance, stats]))
	deck.shuffle()

	if _effect_resolver == null: return #TODO: remove this. required due to null passes on bad local news of players
	effect_resolver = _effect_resolver
	effect_resolver.reflect_effect.connect(_handle_effect)

func _handle_effect(effect : Effect) -> void:
	print("Reflecting effect '%s'." % [effect])
	# if effect is GamefieldEffect: _handle_gamefield_effect(effect as GamefieldEffect)
	if effect is PlayerEffect: _handle_player_effect(effect as PlayerEffect)

# func _handle_gamefield_effect(effect : GamefieldEffect) -> void:
# 	if effect is CreatureSpawnEffect:
# 		var spawn_effect := effect as CreatureSpawnEffect
# 		cards_on_field.append(spawn_effect.creature)
# 	if effect is CreatureLeavePlayEffect:
# 		var leave_effect := effect as CreatureLeavePlayEffect
# 		cards_on_field.erase(leave_effect.creature)
# 	UIEventBus.submit_effect(effect)

func _handle_player_effect(effect : PlayerEffect) -> void:
	if effect is HandEffect:
		_handle_hand_effect(effect as HandEffect)

func _handle_hand_effect(effect : HandEffect) -> void:
	if effect is HandAddCardEffect:
		var add_effect : HandAddCardEffect = effect as HandAddCardEffect
		match [add_effect.from_deck, add_effect.specific_card]:
			[true, false]: # Regular Draw
				var drawn_card : CardInDeck = deck.draw_card()
				if drawn_card == null: 
					push_warning("Deck has no cards. Did you run out?")
					return 
				var card_in_hand : CardInHand = CardInHand.new([
					ICardInstance.id(drawn_card), 
					IStatisticPossessor.id(drawn_card), 
					IMoodPossessor.id(drawn_card),
				])
				print(card_in_hand.get_children())
				cards_in_hand.append(card_in_hand)
				IStatisticPossessor.id(card_in_hand).set_statistic(Genesis.Statistic.IS_IN_HAND, true)
				
			[false, true]: # Spawn New Card
				# var card_meta : CardMetadata = CardDB.get_card_by_id(add_effect.card_metadata_id)
				# hand.append(card_meta)
				# TODO: fix
				pass # BRO I DO NOT FUCKING CARE
			[true, true]: # Search
				pass
			[false, false]: 
				push_error("Invalid HandAddCardEffect")
				#TODO: Give a totally random card?

	# if effect is HandBurnHandEffect:
	# 	var num_cards : int = cards_in_hand.size()
	# 	cards_in_hand.clear()
	# 	#TODO: clearing hand occurs through effect
	# 	# ^ bro what why. show your mf work dog.
	# 	for i in range(num_cards):
	# 		AuthoritySourceProvider.authority_source.request_effect(
	# 			HandAddCardEffect.new(self, false, true, 0)
	# 		)

	if effect is HandRemoveCardEffect:
		var remove_effect : HandRemoveCardEffect = effect as HandRemoveCardEffect
		cards_in_hand.erase(remove_effect.card)
		IStatisticPossessor.id(remove_effect.card).set_statistic(Genesis.Statistic.IS_IN_HAND, false)

	UIEventBus.submit_action(
		CustomAction.new(
			"player_hand_changed",
			{
				"player" : self
			}
	))
