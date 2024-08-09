class_name WasAttackedEvent
extends Event

var card : ICardInstance
var by : ICardInstance

func _init(_card : ICardInstance, _by : ICardInstance) -> void:
	card = _card
	by = _by

func _to_string() -> String:
	return "EnteredDeckEvent(%s,%s)" % [card, by]