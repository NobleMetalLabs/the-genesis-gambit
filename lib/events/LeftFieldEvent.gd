class_name LeftFieldEvent
extends Event

var card : ICardInstance
var reason : Genesis.LeavePlayReason

func _init(_card : ICardInstance, _reason : Genesis.LeavePlayReason = Genesis.LeavePlayReason.DIED) -> void:
	self.card = _card
	self.reason = _reason

func _to_string() -> String:
	return "LeftFieldEvent(%s, %s)" % [self.card, self.reason]
