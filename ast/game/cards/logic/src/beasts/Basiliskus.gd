extends CardLogic

static var description : StringName = "Targeted creature receives Jolly, and 5 Slow."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if not my_stats.get_statistic(Genesis.Statistic.HAS_TARGET): return
	var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
	var target_moods := IMoodPossessor.id(target)
	_effect_resolver.request_effect(
		ApplyMoodEffect.new(
			instance_owner,
			target_moods,
			StatisticMood.JOLLY(instance_owner)
		)
	)
	_effect_resolver.request_effect(
		ApplyMoodEffect.new(
			instance_owner,
			target_moods,
			StatisticMood.SLOW(instance_owner, 5)
		)
	)