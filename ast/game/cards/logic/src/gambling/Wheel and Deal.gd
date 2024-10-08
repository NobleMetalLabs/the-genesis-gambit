extends CardLogic

static var description : StringName = "All players discard their hands and draw seven new cards."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	if not IStatisticPossessor.id(instance_owner).get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	for player : Player in _backend_objects.players:
		for card : ICardInstance in player.cards_in_hand:
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
				DeckDrawCardEffect.new(
					instance_owner,
					player,
				)
			)
