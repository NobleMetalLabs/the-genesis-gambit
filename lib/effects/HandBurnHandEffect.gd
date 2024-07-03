class_name HandBurnHandEffect
extends HandEffect

func _init(_requester : Object, _player : Player) -> void:
	self.requester = _requester
	self.player = _player

func _to_string() -> String:
	return "HandBurnHandEffect(%s)" % self.player

func resolve(_effect_resolver : EffectResolver) -> void:
	for card : CardInHand in self.player.cards_in_hand:
		_effect_resolver.request_effect(HandRemoveCardEffect.new(
			self.requester, self.player, card, Genesis.LeaveHandReason.BURNED
		))