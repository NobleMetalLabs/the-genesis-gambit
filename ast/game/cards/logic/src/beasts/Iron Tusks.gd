extends CardLogic

static var description : StringName = "Targeted creature recieves Angry."

var previous_target : ITargetable = null

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
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
		effect_resolver.request_effect(
			ApplyMoodEffect.new(
				instance_owner,
				IMoodPossessor.id(target), 
				StatisticMood.ANGRY(instance_owner)
			)
		)
		previous_target = target