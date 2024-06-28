extends CardLogic

static var description : StringName = "Targeted creature is covered in ooze. Attacks made against the creature inflict the attacker with slow."

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
		if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
			for effect in effect_resolver.effect_list:
				if not effect is CreatureAttackEffect: continue
				effect = effect as CreatureAttackEffect
				if not effect.target == target: continue
				effect_resolver.request_effect(
					ApplyMoodEffect.new(
						self,
						IMoodPossessor.id(effect.creature),
						StatisticMood.SLOW(instance_owner)
					)
				)