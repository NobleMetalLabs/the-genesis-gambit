extends CardLogic

static var description : StringName = "Activate creature to sacrifice it. Gain 5 maximum energy."

func process(_effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic("just_activated"):
		my_stats.set_statistic("just_died", true)
		my_stats.set_statistic("just_sacrificed", true)
		var my_player : Player = instance_owner.player
		IStatisticPossessor.id(my_player).modify_statistic("maximum_energy", 5)


