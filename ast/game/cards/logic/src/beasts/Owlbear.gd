extends CardLogic

static var description : StringName = "Activate: When Targeted Attacker makes its next attack, if its strength is higher than the target's health, deal the difference to the owner of the target."

var watching_creatures : Array[ICardInstance]

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_staticic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
			if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
				var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
				watching_creatures.append(ICardInstance.id(target))

	for effect in _effect_resolver.effect_list:
		if not effect is CreatureAttackEffect: continue
		effect = effect as CreatureAttackEffect
		if not effect.creature in watching_creatures: continue
		var attacker_stats := IStatisticPossessor.id(effect.creature)
		var target_stats := IStatisticPossessor.id(effect.target)
		var attacker_strength : int = attacker_stats.get_statistic(Genesis.Statistic.STRENGTH)
		var target_strength : int = target_stats.get_statistic(Genesis.Statistic.STRENGTH)
		if attacker_strength > target_strength:
			var damage : int = attacker_strength - target_strength
			_effect_resolver.request_effect(
				ModifyStatisticEffect.new(
					instance_owner,
					IStatisticPossessor.id(instance_owner.player.leader),
					Genesis.Statistic.HEALTH,
					-damage
				)
			)
		watching_creatures.erase(effect.creature)
