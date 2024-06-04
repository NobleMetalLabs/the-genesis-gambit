extends CardLogic

static var description : StringName = "When played, gain 3 activations. Activate: ShiftRegister makes an attack against itself for 0 damage."

func process(_gs : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	if not is_on_field: return
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		my_stats.set_statistic(Genesis.Statistic.NUM_ACTIVATIONS, 3)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.NUM_ACTIVATIONS) > 0:
			my_stats.modify_statistic(Genesis.Statistic.NUM_ACTIVATIONS, -1)
			var attack_effect := CreatureAttackEffect.new(
					instance_owner.get_object(),
					instance_owner.get_object(),
					0
				)
			attack_effect.requester = instance_owner
			_effect_resolver.request_effect(attack_effect)

			print("Added attack effect")
			print(attack_effect in _effect_resolver.effect_list)
					
		else:
			print("Not enough activations")
