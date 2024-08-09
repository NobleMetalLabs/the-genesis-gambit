class_name WasBurnedEvent
extends Event

var card : ICardInstance

func _init(_card : ICardInstance) -> void:
	self.card = _card

func _to_string() -> String:
	return "WasBurnedEvent(%s)" % self.card