class_name WasSupportedEvent
extends Event

var card : ICardInstance
var by : ICardInstance

func _init(_card : ICardInstance, _who : ICardInstance) -> void:
	self.card = _card
	self.who = _who

func _to_string() -> String:
	return "WasSupportedEvent(%s, %s)" % [self.card, self.who]

