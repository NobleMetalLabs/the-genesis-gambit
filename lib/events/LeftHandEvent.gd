class_name LeftHandEvent
extends Event

var card : ICardInstance
var reason : Genesis.LeaveHandReason

func _init(_card : ICardInstance, _reason : Genesis.LeaveHandReason = Genesis.LeaveHandReason.PLAYED) -> void:
	self.card = _card
	self.reason = _reason

func _to_string() -> String:
	return "LeftHandEvent(%s)" % [self.card]
