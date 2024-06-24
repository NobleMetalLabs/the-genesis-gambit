extends CardLogic

static var description : StringName = "Search your deck for the bottom-most Mythic card, then shuffle and put that card on top."

func process(_gs : GamefieldState, _er : EffectResolver) -> void:
	if not IStatisticPossessor.id(instance_owner).get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	var player_deck : Deck = instance_owner.player.deck
	var cards : Array = player_deck.get_cards()
	cards.reverse()
	for card : CardInDeck in cards:
		if ICardInstance.id(card).metadata.rarity == Genesis.CardRarity.MYTHIC:
			player_deck.remove_card(card)
			player_deck.insert_card(card, 0)
			return
	
	