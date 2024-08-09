class_name WasDiscardedEvent
extends Event

var card : ICardInstance

func _init(_card : ICardInstance) -> void:
	self.card = _card

func _to_string() -> String:
	return "WasDiscardedEvent(%s)" % self.card