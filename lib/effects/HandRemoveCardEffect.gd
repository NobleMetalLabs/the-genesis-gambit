class_name HandRemoveCardEffect
extends HandEffect

var card : CardInHand
var leave_reason : Genesis.LeaveHandReason
var animation : Genesis.CardRemoveAnimation

func _init(_requester : Object, _player : Player, _card : CardInHand, _leave_reason : Genesis.LeaveHandReason, _animation : Genesis.CardRemoveAnimation = Genesis.CardRemoveAnimation.INHERIT) -> void:
	self.requester = _requester
	self.player = _player
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "HandRemoveCardEffect(%s,%s,%s,%s)" % [self.player, self.card, self.leave_reason, self.animation]

func resolve(_effect_resolver : EffectResolver) -> void:
	var card_instance := ICardInstance.id(self.card)
	IStatisticPossessor.id(self.card).set_statistic(Genesis.Statistic.IS_IN_HAND, false)

	if leave_reason == Genesis.LeaveHandReason.DISCARDED or leave_reason == Genesis.LeaveHandReason.BURNED:
		_effect_resolver.request_effect(DeckAddCardEffect.new(
			self.requester, self.player, card_instance
		))

		if leave_reason == Genesis.LeaveHandReason.BURNED:
			_effect_resolver.request_effect(HandAddCardEffect.new(
				self.requester, self.player
			))
	if leave_reason == Genesis.LeaveHandReason.PLAYED:
		_effect_resolver.request_effect(CreatureSpawnEffect.new(
			self.requester, card_instance
		))

	Router.client_ui.refresh_hand_ui() #This doesn't act completely as expected. Cards can't be nowhere, so they remain in the last location while statistics report a limbo state. 
	# Basically a card not in the hand may still render in the hand.
	# This is generally indiciative of below.
	# TODO: Remove UI updates from effect resolution. EffectResolver should provide effects to ClientUI wholesale, and ClientUI should handle them seperately.
	
