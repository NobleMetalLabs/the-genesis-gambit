class_name WasMarkedEvent
extends Event

var card : ICardInstance

func _init(_card : ICardInstance) -> void:
	self.event_type = "WAS_MARKED"
	self.card = _card

func _to_string() -> String:
	return "WasMarkedEvent(%s)" % self.card
