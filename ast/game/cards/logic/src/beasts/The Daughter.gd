extends CardLogic

static var description : StringName = "When this creature is killed, the attacker is also killed."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_KILLED):
		var attacker : ICardInstance = my_stats.get_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED_BY)
		_effect_resolver.request_effect(
			CreatureLeavePlayEffect.new(
				instance_owner,
				attacker.get_object(),
				instance_owner
			)
		)
