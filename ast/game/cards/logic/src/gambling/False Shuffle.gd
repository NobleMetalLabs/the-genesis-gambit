extends CardLogic

static var description : StringName = "Search your deck for the bottom-most Mythic card, then shuffle and put that card on top."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	if not IStatisticPossessor.id(instance_owner).get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	var player_deck : Array[CardInDeck] = _gamefield_state.get_player_from_instance(instance_owner).cards_in_deck
	var pdc : Array[CardInDeck] = player_deck.duplicate()
	pdc.reverse()
	for card : CardInDeck in pdc:
		if ICardInstance.id(card).metadata.rarity == Genesis.CardRarity.MYTHIC:
			player_deck.erase(card)
			player_deck.insert(0, card)
			return
	
	