extends CardLogic

static var description : StringName = "When targeted creature is killed, the attacker receives summoning sickness."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if not my_stats.get_statistic(Genesis.Statistic.HAS_TARGET): return
	var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
	var target_stats := IStatisticPossessor.id(target)
	if target_stats.get_statistic(Genesis.Statistic.JUST_DIED):
		var attacker : ICardInstance = target_stats.get_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED_BY)
		_effect_resolver.request_effect(
			ApplyMoodEffect.new(
				instance_owner,
				IMoodPossessor.id(attacker),
				SummoningMood.new(instance_owner)
			)
		)