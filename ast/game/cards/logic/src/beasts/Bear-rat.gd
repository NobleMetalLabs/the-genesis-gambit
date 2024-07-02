extends CardLogic

static var description : StringName = "Activate: Unmark targeted card. Unmark the twenty-second card in the deck. Cannot be activated again until it is attacked."

func process(_gs : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) == 0:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, 1)

	if my_stats.get_staticic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
			if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
				var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
				IStatisticPossessor.id(target).set_statistic(Genesis.Statistic.IS_MARKED, false)
			if instance_owner.player.deck.get_cards().size() > 21:
				var twentysecond_card := instance_owner.player.deck.get_cards()[21]
				IStatisticPossessor.id(twentysecond_card).set_statistic(Genesis.Statistic.IS_MARKED, false)