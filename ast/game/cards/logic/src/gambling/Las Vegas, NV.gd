extends CardLogic

static var description : StringName = "Activate: All of your cards on the field receive Sad and Enlightened. Cannot be activated until played again."

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		my_stats.set_statistic(Genesis.Statistic.CHARGES, 1)

	if my_stats.get_staticic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
			for cof : CardOnField in instance_owner.player.cards_on_field:
				var card := ICardInstance.id(cof)
				effect_resolver.request_effect(
					ApplyMoodEffect.new(
						instance_owner,
						IMoodPossessor.id(card),
						StatisticMood.SAD(instance_owner),
					)
				)
				effect_resolver.request_effect(
					ApplyMoodEffect.new(
						instance_owner,
						IMoodPossessor.id(card),
						StatisticMood.ENLIGHTENED(instance_owner),
					)
				)