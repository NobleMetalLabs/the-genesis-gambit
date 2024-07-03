extends CardLogic

static var description : StringName = "When this creature dies, gain 3 health."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_DIED):
		var my_player : Player = _gamefield_state.get_player_from_instance(instance_owner)
		IStatisticPossessor.id(my_player).modify_statistic(Genesis.Statistic.HEALTH, 3)



# RevengerAutomaton
# extends CardLogic

# static var description : StringName = "When any friendly creature dies, this creature gains Anger."

# func process(_gamefield_state : GamefieldState, ) -> void:
#	pass