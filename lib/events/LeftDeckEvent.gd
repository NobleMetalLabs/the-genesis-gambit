class_name LeftDeckEvent
extends Event

var card : ICardInstance
var leave_reason : Genesis.LeaveDeckReason
var animation : Genesis.CardRemoveAnimation

func _init(_card : ICardInstance, _leave_reason : Genesis.LeaveDeckReason, _animation : Genesis.CardRemoveAnimation = Genesis.CardRemoveAnimation.INHERIT) -> void:
	self.card = _card
	self.leave_reason = _leave_reason
	self.animation = _animation

func _to_string() -> String:
	return "DeckRemoveCardEffect(%s,%s,%s,%s)" % [self.card, self.leave_reason, self.animation]