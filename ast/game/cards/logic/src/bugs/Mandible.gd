extends CardLogic

static var description : StringName = "Targeted creature gains 2 Strength."

var previous_target : ITargetable = null

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_TARGETED):
		var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
		var target_stats := IStatisticPossessor.id(target)
		if target == previous_target: return
		if previous_target != null:
			effect_resolver.request_effect(
				ModifyStatisticEffect.new(
					instance_owner,
					target_stats,
					Genesis.Statistic.STRENGTH,
					-2
				)
			)
		effect_resolver.request_effect(
			ModifyStatisticEffect.new(
				instance_owner,
				target_stats,
				Genesis.Statistic.STRENGTH,
				2
			)
		)
		previous_target = target