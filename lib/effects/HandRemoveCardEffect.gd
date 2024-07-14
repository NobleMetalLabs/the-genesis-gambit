class_name HandRemoveCardEffect
extends HandEffect

var card : ICardInstance
var leave_reason : Genesis.LeaveHandReason
var animation : Genesis.CardRemoveAnimation

func _init(_requester : Object, _player : Player, _card : ICardInstance, _leave_reason : Genesis.LeaveHandReason, _animation : Genesis.CardRemoveAnimation = Genesis.CardRemoveAnimation.INHERIT) -> void:
	self.requester = _requester
	self.player = _player
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "HandRemoveCardEffect(%s,%s,%s,%s)" % [self.player, self.card, self.leave_reason, self.animation]

func resolve(_effect_resolver : EffectResolver) -> void:
	IStatisticPossessor.id(self.card).set_statistic(Genesis.Statistic.IS_IN_HAND, false)
	player.cards_in_hand.erase(self.card)

	if leave_reason == Genesis.LeaveHandReason.DISCARDED or leave_reason == Genesis.LeaveHandReason.BURNED:
		_effect_resolver.request_effect(DeckAddCardEffect.new(
			self.requester, self.player, self.card
		))

		if leave_reason == Genesis.LeaveHandReason.BURNED:
			_effect_resolver.request_effect(HandAddCardEffect.new(
				self.requester, self.player
			))
			
	if leave_reason == Genesis.LeaveHandReason.PLAYED:
		_effect_resolver.request_effect(CreatureSpawnEffect.new(
			self.requester, self.card
		))
	
