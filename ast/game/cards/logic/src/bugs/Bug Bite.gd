extends CardLogic

static var description : StringName = "Targeted creature is dealt 2 damage."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_TARGETED):
		var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
		_effect_resolver.request_effect(
			ModifyStatisticEffect.new(
				instance_owner,
				IStatisticPossessor.id(target),
				Genesis.Statistic.HEALTH,
				-2
			)
		)