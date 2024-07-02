extends CardLogic

static var description : StringName = "Each first attack made by a creature against Moth deals no damage."

var has_been_attacked_by : Array[ICardInstance] = []

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var my_target := ITargetable.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
		for effect : Effect in effect_resolver.effect_list:
			if not effect is CreatureAttackEffect: continue
			var attack_effect := effect as CreatureAttackEffect
			if attack_effect.target != my_target: continue
			if attack_effect.creature in has_been_attacked_by: continue
			has_been_attacked_by.append(attack_effect.creature)
			attack_effect.damage = 0
		