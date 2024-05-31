extends CardLogic

static var description : StringName = "Gain 3 health. Draw a card."

func process(_effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic("just_placed"):
		my_stats.set_statistic("just_died", true)
		var my_player : Player = instance_owner.player
		IStatisticPossessor.id(my_player).modify_statistic("health", 3)
		AuthoritySourceProvider.authority_source.request_action(
			HandAddCardAction.new(my_player)
		)
