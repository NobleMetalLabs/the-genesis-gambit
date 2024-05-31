extends CardLogic

static var description : StringName = "Creature cannot attack. Attacking creatures you control gain +1 damage."

func process(_effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic("just_activated"):
		my_stats.set_statistic("cannot_attack", true)


