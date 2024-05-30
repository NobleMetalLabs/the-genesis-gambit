extends CardLogic

static var description : StringName = "Target creature attacks itself."

func process() -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic("has_target"):
		var target : ITargetable = my_stats.get_statistic("target")
		var target_card : CardOnField = target.get_object()
		AuthoritySourceProvider.authority_source.request_action(
			CreatureAttackAction.new(
				target_card, target_card, IStatisticPossessor.id(target).get_statistic("strength")
			)
		)


# Bandwagoner
# extends CardLogic

# static var description : StringName = "Whenever an opponents creature is attacked, this creature attacks the same target."

# func _process(game_state := GamefieldState.new()) -> void:
# 	var my_stats := IStatisticPossessor.id(instance_owner)
# 	var opponent_cards : Array[ICardInstance] = []
# 	opponent_cards = game_state.players.map(
# 		func(p : Player) -> Array: 
# 			return p.cards_in_hand.map(func (c : CardInHand) -> ICardInstance: return ICardInstance.id(c)) + \
# 				p.cards_on_field.map(func (c : CardOnField) -> ICardInstance: return ICardInstance.id(c)) + \
# 				p.deck.get_cards()
# 	).filter(func(c : ICardInstance) -> bool: return c.player != instance_owner.player)

# 	for card in opponent_cards:
# 		var card_stats := IStatisticPossessor.id(card)
# 		if card_stats.get_statistic("was_just_attacked"):
# 			AuthoritySourceProvider.authority_source.request_action(
# 				CreatureAttackAction.new(
# 					instance_owner, card, my_stats.get_statistic("strength")
# 				)
# 			)

# Gain Experience
# extends CardLogic

# static var description : StringName = "Whenever Target Creature attacks, it gains +1 power."

