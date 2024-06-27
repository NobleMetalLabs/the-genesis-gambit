extends CardLogic

static var description : StringName = "When played, gain 3 activations. Activate: ShiftRegister gives itself anger."

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	if not is_on_field: return
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		var get_mood_effect := ApplyMoodEffect.new(
			instance_owner,
			IMoodPossessor.id(instance_owner), 
			StatisticMood.ANGRY(instance_owner)
		)
		get_mood_effect.requester = instance_owner
		effect_resolver.request_effect(get_mood_effect)
		
