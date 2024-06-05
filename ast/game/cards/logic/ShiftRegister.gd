extends CardLogic

static var description : StringName = "When played, gain 3 activations. Activate: ShiftRegister makes an attack against itself for 0 damage."

func process(_gs : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	if not is_on_field: return
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		var leave_play_effect := CreatureLeavePlayEffect.new(
			instance_owner.get_object(), instance_owner
		)
		leave_play_effect.requester = instance_owner
		_effect_resolver.request_effect(leave_play_effect)
		
