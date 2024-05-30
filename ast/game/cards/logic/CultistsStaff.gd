extends CardLogic

static var description : StringName = "Targeted Creature gains 2 Weak."

func process() -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic("has_target"):
		var target : ITargetable = my_stats.get_statistic("target")
		var target_moods := IMoodPossessor.id(target)

		var mood_applied : bool = false
		for mood : Mood in target_moods.get_moods():
			if mood.source == instance_owner:
				mood_applied = true
				break
		if not mood_applied:
			target_moods.apply_mood(StatisticMood.new(
				"strength", Mood.MoodEffect.NEGATIVE, instance_owner, 2
			))