class_name HandRemoveCardEffect
extends HandEffect

var card : CardInHand
var leave_reason : HandRemoveCardAction.LeaveReason
var animation : HandRemoveCardAction.CardRemoveAnimation

func _init(_player : Player, _card : CardInHand, _leave_reason : HandRemoveCardAction.LeaveReason, _animation : HandRemoveCardAction.CardRemoveAnimation) -> void:
	self.player = _player
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "HandRemoveCardEffect(%s,%s,%s,%s)" % [self.player, self.card, self.leave_reason, self.animation]