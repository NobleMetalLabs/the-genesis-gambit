extends CardLogic

static var description : StringName = "Target creature with less than 5 health. Creature dies, and their health count is added to Leech's owners health."

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	for effect : Effect in effect_resolver.effect_list:
		if not effect is CreatureTargetEffect: continue
		var target_effect := effect as CreatureTargetEffect
		var target_card := ICardInstance.id(target_effect.target)
		var target_stats := IStatisticPossessor.id(target_card)
		if target_stats.get_statistic(Genesis.Statistic.HEALTH) >= 5:
			effect.resolve_status = Effect.ResolveStatus.FAILED
			return
	if my_stats.get_statistic(Genesis.Statistic.JUST_TARGETED):
		var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
		effect_resolver.request_effect(
			CreatureLeavePlayEffect.new(
				instance_owner,
				ICardInstance.id(target),
				instance_owner,
			)
		)
		var player_stats := IStatisticPossessor.id(instance_owner.player)
		var target_stats := IStatisticPossessor.id(target)
		player_stats.modify_statistic(Genesis.Statistic.HEALTH, target_stats.get_statistic(Genesis.Statistic.HEALTH))