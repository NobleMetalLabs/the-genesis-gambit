extends CardLogic

static var description : StringName = "Activate: Target attacker gets +1 Strength. Box of Chips loses one health."

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
				_effect_resolver.request_effect(
					ModifyStatisticEffect.new(
						instance_owner,
						IStatisticPossessor.id(target),
						Genesis.Statistic.STRENGTH,
						1
					)
				)
				_effect_resolver.request_effect(
					ModifyStatisticEffect.new(
						instance_owner,
						my_stats,
						Genesis.Statistic.HEALTH,
						-1
					)
				)