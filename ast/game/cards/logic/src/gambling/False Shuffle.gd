extends CardLogic

static var description : StringName = "Search your deck for the bottom-most Mythic card, then shuffle and put that card on top."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	if not IStatisticPossessor.id(instance_owner).get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	var player_deck : Array[ICardInstance] = instance_owner.player.cards_in_deck
	var pdc : Array[ICardInstance] = player_deck.duplicate()
	pdc.reverse()
	for card : ICardInstance in pdc:
		if card.metadata.rarity == Genesis.CardRarity.MYTHIC:
			player_deck.erase(card)
			player_deck.shuffle()
			player_deck.insert(0, card)
			return
	
	