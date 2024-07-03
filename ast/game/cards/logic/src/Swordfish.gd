extends CardLogic

static var description : StringName = "While on field, for friendly creatures, all positive moods become negative and vice versa."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	if not is_on_field: return
	for effect : Effect in _effect_resolver.effect_list:
		if not effect is ApplyMoodEffect: continue
		effect = effect as ApplyMoodEffect
		effect.mood.effect = Mood.invert_effect(effect.mood.effect)
		
