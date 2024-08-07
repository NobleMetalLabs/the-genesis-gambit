extends CardLogic

static var description : StringName = "Target creature gains Anger."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		IMoodPossessor.id(target).apply_mood(StatisticMood.new(
			instance_owner, Genesis.Statistic.STRENGTH, Mood.MoodEffect.POSITIVE, 1
		))
