extends CardLogic

static var description : StringName = "Each player draws 2 cards. If there are more than 3 players in the game, you draw a third."

func process(gamefield_state : GamefieldState, effect_resolver : EffectResolver) -> void:
	if not IStatisticPossessor.id(instance_owner).get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	for player in gamefield_state.players:
		for _i in range(2):
			effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					player,
				)
			)
	if gamefield_state.players.size() > 3:
		effect_resolver.request_effect(
			HandAddCardEffect.new(
				instance_owner,
				instance_owner.player,
			)
		)
