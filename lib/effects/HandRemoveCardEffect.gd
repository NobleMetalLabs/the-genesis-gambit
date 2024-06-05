class_name HandRemoveCardEffect
extends HandEffect

var card : CardInHand
var leave_reason : Genesis.LeaveHandReason
var animation : Genesis.CardRemoveAnimation

func _init(_player : Player, _card : CardInHand, _leave_reason : Genesis.LeaveHandReason, _animation : Genesis.CardRemoveAnimation = Genesis.CardRemoveAnimation.INHERIT) -> void:
	self.player = _player
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "HandRemoveCardEffect(%s,%s,%s,%s)" % [self.player, self.card, self.leave_reason, self.animation]

func resolve(effect_resolver : EffectResolver) -> void:
	var card_instance := ICardInstance.id(self.card)
	IStatisticPossessor.id(self.card).set_statistic(Genesis.Statistic.IS_IN_HAND, false)

	if leave_reason == Genesis.LeaveHandReason.DISCARDED or leave_reason == Genesis.LeaveHandReason.BURNED:
		var deck_add_card_effect := DeckAddCardEffect.new(
			self.player, card_instance
		)
		deck_add_card_effect.requester = self.requester
		effect_resolver.request_effect(deck_add_card_effect)

		if leave_reason == Genesis.LeaveHandReason.BURNED:
			var replacement_card_effect := HandAddCardEffect.new(
				self.player
			)
			replacement_card_effect.requester = self.requester
			effect_resolver.request_effect(replacement_card_effect)
	if leave_reason == Genesis.LeaveHandReason.PLAYED:
		var creature_spawn_effect := CreatureSpawnEffect.new(
			card_instance
		)
		creature_spawn_effect.requester = self.requester
		effect_resolver.request_effect(creature_spawn_effect)

	Router.client_ui.refresh_hand_ui() #This doesn't act completely as expected. Cards can't be nowhere, so they remain in the last location while statistics report a limbo state. 
	# Basically a card not in the hand may still render in the hand.
	# This is generally indiciative of below.
	# TODO: Remove UI updates from effect resolution. EffectResolver should provide them to ClientUI, and ClientUI should handle them seperately.
	
