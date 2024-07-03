extends CardLogic

static var description : StringName = "Gain 3 health. Draw a card."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		my_stats.set_statistic(Genesis.Statistic.JUST_DIED, true)
		var my_player : Player = _gamefield_state.get_player_from_instance(instance_owner)
		IStatisticPossessor.id(my_player).modify_statistic(Genesis.Statistic.HEALTH, 3) 
		AuthoritySourceProvider.authority_source.request_action(
			HandAddCardAction.new(my_player)
		)
