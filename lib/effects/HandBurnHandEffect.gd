class_name HandBurnHandEffect
extends HandEffect

func _init(_requester : Object, _player : Player) -> void:
	self.requester = _requester
	self.player = _player

func _to_string() -> String:
	return "HandBurnHandEffect(%s)" % self.player

func resolve(_effect_resolver : EffectResolver) -> void:
	for card : ICardInstance in self.player.cards_in_hand:
		IStatisticPossessor.id(card).set_statistic(Genesis.Statistic.WAS_JUST_BURNED, true)
		_effect_resolver.request_effect(HandRemoveCardEffect.new(
			self.requester, self.player, card, Genesis.LeaveHandReason.BURNED
		))
	
	_effect_resolver.request_effect(
		CooldownEffect.new(
			self.requester,
			IStatisticPossessor.id(player),
			Genesis.CooldownType.BURN,
			int(60.0 / Genesis.NETWORK_FRAME_PERIOD)
		)
	)
