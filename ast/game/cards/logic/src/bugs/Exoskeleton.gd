extends CardLogic

static var description : StringName = "When Exoskeleton is played, gain 3 charges. Activate: The next attack targeted creature receives deals no damage. When Exoskeleton runs out of charges, it is killed."

var protected_creatures : Array[ICardInstance] = []

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		my_stats.modify_statistic(Genesis.Statistic.CHARGES, 3)

	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
			var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
			if my_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
				my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
				protected_creatures.append(target)
			if my_stats.get_statistic(Genesis.Statistic.CHARGES) == 0:
				_effect_resolver.request_effect(
					CreatureLeavePlayEffect.new(
						self, instance_owner, instance_owner
					)
				)

	if protected_creatures.size() > 0:
		for protected_creature : ICardInstance in protected_creatures.duplicate():
			for effect in _effect_resolver.effect_list:
				if not effect is CreatureAttackEffect: continue
				effect = effect as CreatureAttackEffect
				if not effect.target == protected_creature: continue
				effect.damage = 0
				protected_creatures.erase(protected_creature)
				break
			