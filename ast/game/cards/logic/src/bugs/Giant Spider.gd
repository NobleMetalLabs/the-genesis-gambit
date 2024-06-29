extends CardLogic

static var description : StringName = "When Giant Spider damages an attacker, that attacker receives Slow."

var has_been_attacked_by : Array[ICardInstance] = []

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_ATTACKED):
		for effect : Effect in _effect_resolver.effect_list:
			if not effect is CreatureAttackEffect: continue
			var attack_effect := effect as CreatureAttackEffect
			if attack_effect.creature != instance_owner: continue
			if attack_effect.damage == 0: continue
			var target_card := ICardInstance.id(attack_effect.target)
			_effect_resolver.request_effect(
				ApplyMoodEffect.new(
					instance_owner,
					IMoodPossessor.id(target_card),
					StatisticMood.SLOW(instance_owner, 1)
				)
			)
		
