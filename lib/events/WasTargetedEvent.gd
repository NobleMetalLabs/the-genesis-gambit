class_name WasTargetedEvent
extends Event

var card : ICardInstance
var by : ICardInstance

func _init(_card : ICardInstance, _by : ICardInstance) -> void:
	card = _card
	by = _by

func _to_string() -> String:
	return "WasTargetedEvent(%s, %s)" % [card, by]
