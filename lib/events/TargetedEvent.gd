class_name TargetedEvent
extends Event

var card : ICardInstance
var who : ICardInstance

func _init(_card : ICardInstance, _who : ICardInstance) -> void:
	self.card = _card
	self.who = _who

func _to_string() -> String:
	return "TargetedEvent(%s, %s)" % [self.card, self.who]
	