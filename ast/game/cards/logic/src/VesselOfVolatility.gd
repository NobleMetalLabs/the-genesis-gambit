extends CardLogic

static var description : StringName = "Activate creature to sacrifice it. Gain 5 maximum energy."

func process(_gs : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		my_stats.set_statistic(Genesis.Statistic.JUST_DIED, true)
		my_stats.set_statistic(Genesis.Statistic.WAS_JUST_SACRIFICED, true)
		var my_player : Player = instance_owner.player
		IStatisticPossessor.id(my_player).modify_statistic(Genesis.Statistic.MAX_ENERGY, 5)


