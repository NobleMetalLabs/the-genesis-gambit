class_name WasSupportedEvent
extends Event

var card : ICardInstance
var by : ICardInstance

func _init(_card : ICardInstance, _by : ICardInstance) -> void:
	self.card = _card
	self.by = _by

func _to_string() -> String:
	return "WasSupportedEvent(%s, %s)" % [self.card, self.by]
