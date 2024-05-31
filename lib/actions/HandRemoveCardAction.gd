class_name HandRemoveCardAction
extends HandAction

var card : CardInHand
var leave_reason : LeaveReason
enum LeaveReason {
	PLAYED,
	DISCARDED,
	BANISHED,
}
var animation : CardRemoveAnimation
enum CardRemoveAnimation {
	PLAY,
	DISCARD,
	BURN,
	BANISH,
}

func _init(_player : Player, _card : CardInHand, _leave_reason : LeaveReason, _animation : CardRemoveAnimation) -> void:
	self.player = _player
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "HandRemoveCardAction(%s,%s,%s,%s)" % [self.player, self.card, self.leave_reason, self.animation]

func to_effect() -> HandRemoveCardEffect:
	return HandRemoveCardEffect.new(player, card, leave_reason, animation)