class_name WasActivatedEvent
extends Event

var card : ICardInstance

func _init(_card : ICardInstance) -> void:
	self.card = _card

func _to_string() -> String:
	return "WasActivatedEvent(%s)" % self.card