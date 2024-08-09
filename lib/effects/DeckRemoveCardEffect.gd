class_name DeckRemoveCardEffect
extends HandEffect

var card : ICardInstance
var leave_reason : Genesis.LeaveDeckReason
var animation : Genesis.CardRemoveAnimation

func _init(_requester : Object, _player : Player, _card : ICardInstance, _leave_reason : Genesis.LeaveDeckReason, _animation : Genesis.CardRemoveAnimation = Genesis.CardRemoveAnimation.INHERIT) -> void:
	self.requester = _requester
	self.player = _player
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "DeckRemoveCardEffect(%s,%s,%s,%s)" % [self.player, self.card, self.leave_reason, self.animation]

func resolve(_effect_resolver : EffectResolver) -> void:
	var card_instance := ICardInstance.id(self.card)
	IStatisticPossessor.id(self.card).set_statistic(Genesis.Statistic.IS_IN_DECK, false)
	IStatisticPossessor.id(player).modify_statistic(Genesis.Statistic.NUM_CARDS_LEFT_IN_DECK, -1)

	player.cards_in_deck.erase(card_instance)
	
	if leave_reason == Genesis.LeaveDeckReason.DRAWN:
		_effect_resolver.request_effect(HandAddCardEffect.new(
			self.requester, self.player, card,
		))

	if leave_reason == Genesis.LeaveDeckReason.PLAYED:
		_effect_resolver.request_effect(CreatureSpawnEffect.new(
			self.requester, card_instance
		))
	
