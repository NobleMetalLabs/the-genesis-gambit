extends CardLogic

static var description : StringName = "Each first attack made by a creature against Moth deals no damage."

var has_been_attacked_by : Array[ICardInstance] = []

# doesnt work because the creatureattackeffect is already gone
# perhaps a "recent attacker" stat could be helpful but maybe theres a different way

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
		print(1)
		for effect : Effect in _effect_resolver.effect_list:
			if not effect is CreatureAttackEffect: continue
			print(2)
			var attack_effect := effect as CreatureAttackEffect
			if attack_effect.target != instance_owner: continue
			if attack_effect.creature in has_been_attacked_by: continue
			has_been_attacked_by.append(attack_effect.creature)
			attack_effect.damage = 0
		
