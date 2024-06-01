class_name HandRemoveCardAction
extends HandAction

var card : CardInHand
var leave_reason : Genesis.LeaveReason
var animation : Genesis.CardRemoveAnimation

func _init(_player : Player, _card : CardInHand, _leave_reason : Genesis.LeaveReason, _animation : Genesis.CardRemoveAnimation) -> void:
	self.player = _player
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "HandRemoveCardAction(%s,%s,%s,%s)" % [self.player, self.card, self.leave_reason, self.animation]

func to_effect() -> HandRemoveCardEffect:
	return HandRemoveCardEffect.new(player, card, leave_reason, animation)