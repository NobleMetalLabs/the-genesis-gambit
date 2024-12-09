class_name LeftDeckEvent
extends Event

var card : ICardInstance
var leave_reason : Genesis.LeaveDeckReason

func _init(_card : ICardInstance, _leave_reason : Genesis.LeaveDeckReason) -> void:
	self.event_type = "LEFT_DECK"
	self.card = _card
	self.leave_reason = _leave_reason

func _to_string() -> String:
	return "DeckRemoveCardEffect(%s,%s)" % [self.card, self.leave_reason]