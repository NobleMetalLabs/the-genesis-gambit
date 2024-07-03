extends CardLogic

static var description : StringName = "Targeted creature recieves Quick."

var previous_target : ITargetable = null

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_TARGETED):
		var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
		if target == previous_target: return
		if previous_target != null:
			var p_target_moods := IMoodPossessor.id(previous_target)
			for mood : Mood in p_target_moods._active_moods:
				if mood.source == instance_owner:
					p_target_moods.remove_mood(mood)
					break
		_effect_resolver.request_effect(
			ApplyMoodEffect.new(
				instance_owner,
				IMoodPossessor.id(target), 
				StatisticMood.QUICK(instance_owner)
			)
		)
		previous_target = target