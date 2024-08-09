class_name SupportedEvent
extends Event

var card : ICardInstance
var who : ICardInstance

func _init(_card : ICardInstance, _who : ICardInstance) -> void:
	self.card = _card
	self.who = _who

func _to_string() -> String:
	return "SupportedEvent(%s, %s)" % [self.card, self.who]

