extends CardLogic

static var description : StringName = "Targeted creature is protected. Attacks made against the creature deal half damage."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
			for effect in _effect_resolver.effect_list:
				if not effect is CreatureAttackEffect: continue
				effect = effect as CreatureAttackEffect
				if not effect.target == target: continue
				effect.damage = effect.damage / 2