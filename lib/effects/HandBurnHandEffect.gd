class_name HandBurnHandEffect
extends HandEffect

func _init(_player : Player) -> void:
	self.player = _player

func _to_string() -> String:
	return "HandBurnHandEffect(%s)" % self.player

func resolve(effect_resolver : EffectResolver) -> void:
	for card : CardInHand in self.player.cards_in_hand:
		var hand_remove_effect_by_burn := HandRemoveCardEffect.new(
			self.player, card, Genesis.LeaveHandReason.BURNED
		)
		hand_remove_effect_by_burn.requester = self.requester
		effect_resolver.request_effect(hand_remove_effect_by_burn)