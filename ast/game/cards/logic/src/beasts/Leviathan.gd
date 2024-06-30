extends CardLogic

static var description : StringName = "Activate: Burn your hand, heal Leviathan to full."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_staticic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
			_effect_resolver.request_effect(
				SetStatisticEffect.new(
					instance_owner,
					my_stats,
					Genesis.Statistic.HEALTH,
					instance_owner.metadata.health
				)
			)
			_effect_resolver.request_effect(
				HandBurnHandEffect.new(
					instance_owner,
					instance_owner.player
				)
			)


