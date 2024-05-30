extends CardLogic

static var description : StringName = "Target creature gains Anger."

func process() -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic("has_target"):
		var target : ITargetable = my_stats.get_statistic("target")
		IMoodPossessor.id(target).apply_mood(StatisticMood.new(
			"damage", Mood.MoodEffect.POSITIVE, instance_owner, 1
		))
