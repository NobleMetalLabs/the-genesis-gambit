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
	var card_stats := IStatisticPossessor.id(self.card)
	card_stats.set_statistic(Genesis.Statistic.IS_IN_HAND, false)
	player.cards_in_hand.erase(self.card)

	if leave_reason == Genesis.LeaveHandReason.DISCARDED:
		card_stats.set_statistic(Genesis.Statistic.WAS_JUST_DISCARDED, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, card_stats, Genesis.Statistic.WAS_JUST_DISCARDED, false
		))
		_effect_resolver.request_effect(DeckAddCardEffect.new(
			self.requester, self.player, self.card
		))

	elif leave_reason == Genesis.LeaveHandReason.BURNED:
		card_stats.set_statistic(Genesis.Statistic.WAS_JUST_BURNED, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, card_stats, Genesis.Statistic.WAS_JUST_BURNED, false
		))
		_effect_resolver.request_effect(HandAddCardEffect.new(
			self.requester, self.player
		))
		
	elif leave_reason == Genesis.LeaveHandReason.PLAYED:
		card_stats.set_statistic(Genesis.Statistic.WAS_JUST_PLAYED, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, card_stats, Genesis.Statistic.WAS_JUST_PLAYED, false
		))
		_effect_resolver.request_effect(CreatureSpawnEffect.new(
			self.requester, self.card
		))
	
