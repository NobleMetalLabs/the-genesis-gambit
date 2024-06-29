extends CardLogic

static var description : StringName = "Activate: Unmark targeted card. Unmark the twenty-second card in the deck. Cannot be activated again until it is attacked."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) == 0:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, 1)

	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
			if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
				var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
				IStatisticPossessor.id(target).set_statistic(Genesis.Statistic.IS_MARKED, false)
			var my_player : Player = _gamefield_state.get_player_from_instance(instance_owner)
			if my_player.cards_in_deck.size() > 21:
				var twentysecond_card : CardInDeck = instance_owner.player.cards_in_deck[21] #TODO: HOLY MEEBLE WHAT HAVE I DONE
				IStatisticPossessor.id(twentysecond_card).set_statistic(Genesis.Statistic.IS_MARKED, false)