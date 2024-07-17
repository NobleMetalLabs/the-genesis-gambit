extends CardLogic

static var description : StringName = "Each player draws 2 cards. If there are more than 3 players in the game, you draw a third."

func process(_backend_state : MatchBackendState, _effect_resolver : EffectResolver) -> void:
	if not IStatisticPossessor.id(instance_owner).get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	for player : Player in _backend_state.players:
		for _i in range(2):
			_effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					player,
				)
			)
	if _backend_state.players.size() > 3:
		_effect_resolver.request_effect(
			HandAddCardEffect.new(
				instance_owner,
				_backend_state.get_player_from_instance(instance_owner),
			)
		)
