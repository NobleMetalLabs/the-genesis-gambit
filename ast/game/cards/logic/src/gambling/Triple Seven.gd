extends CardLogic

static var description : StringName = "Targeted creature receives 3 Anger. If the target is Double Zero, it instead receives 7 Anger."

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
		
		var anger_count : int = 3
		if ICardInstance.id(target).metadata.name == "Double Zero": anger_count = 7
		effect_resolver.request_effect(
			ApplyMoodEffect.new(
				instance_owner,
				IMoodPossessor.id(target), 
				StatisticMood.ANGRY(instance_owner, anger_count)
			)
		)
		previous_target = target