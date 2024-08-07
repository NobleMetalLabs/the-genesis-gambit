extends CardLogic

static var description : StringName = "Target creature with less than 5 health. Creature dies, and their health count is added to Leech's owners health."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if not my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD): return
	if my_stats.get_cooldown_of_type(Genesis.CooldownType.SSICKNESS) != null: return

	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		var target_stats := IStatisticPossessor.id(target)

		if target_stats == null:
			print("lol null target")
			return

		var target_health : int = target_stats.get_statistic(Genesis.Statistic.HEALTH)
		if target_health >= 5: return

		_effect_resolver.request_effect(
			CreatureLeavePlayEffect.new(
				instance_owner,
				target,
				instance_owner,
			)
		)
		var player_stats := IStatisticPossessor.id(instance_owner.player)
		
		player_stats.modify_statistic(Genesis.Statistic.HEALTH, target_stats.get_statistic(Genesis.Statistic.HEALTH))
