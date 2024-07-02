extends CardLogic

static var description : StringName = "Targeted Creature gains 2 Weak."

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
		var target_moods := IMoodPossessor.id(target)

		var mood_applied : bool = false
		for mood : Mood in target_moods.get_moods():
			if mood.source == instance_owner:
				mood_applied = true
				break
		if not mood_applied:
			effect_resolver.request_effect(
				ApplyMoodEffect.new(
					instance_owner,
					target_moods,
					StatisticMood.WEAK(instance_owner, 2)
				)
			)