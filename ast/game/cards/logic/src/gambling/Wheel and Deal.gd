extends CardLogic

static var description : StringName = "All players discard their hands and draw seven new cards."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	if not IStatisticPossessor.id(instance_owner).get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	for player in _gamefield_state.players:
		for card : CardInHand in player.cards_in_hand:
			_effect_resolver.request_effect(
				HandRemoveCardEffect.new(
					instance_owner,
					player,
					card,
					Genesis.LeaveHandReason.DISCARDED,
				)
			)
		for _i in range(7):
			_effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					player,
				)
			)
