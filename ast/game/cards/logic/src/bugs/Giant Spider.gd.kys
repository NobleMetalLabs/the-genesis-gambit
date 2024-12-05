extends CardLogic

static var description : StringName = "When Giant Spider damages an attacker, that attacker receives Slow."

var has_been_attacked_by : Array[ICardInstance] = []

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_ATTACKED):
		var target_card : ICardInstance = my_stats.get_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED)
		_effect_resolver.request_effect(
			ApplyMoodEffect.new(
				instance_owner,
				IMoodPossessor.id(target_card),
				StatisticMood.SLOW(instance_owner, 1)
			)
		)
	
