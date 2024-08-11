class_name DeckDrawCardEffect
extends HandEffect

func _init(_requester : Object, _player : Player) -> void:
	self.requester = _requester
	self.player = _player

func _to_string() -> String:
	return "DeckDrawCardEffect(%s)" % [self.player]

func resolve(_effect_resolver : EffectResolver) -> void:
	var hand_size : int = IStatisticPossessor.id(player).get_statistic(Genesis.Statistic.MAX_HAND_SIZE)
	if self.player.cards_in_hand.size() >= hand_size:
		self.resolve_status = ResolveStatus.FAILED
		return

	_effect_resolver.request_effect(DeckRemoveCardEffect.new(
		self.requester, self.player, self.player.cards_in_deck.pop_front(), Genesis.LeaveDeckReason.DRAWN
	))
	
