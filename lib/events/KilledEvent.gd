class_name KilledEvent
extends Event

var card : ICardInstance
var who : ICardInstance

func _init(_card : ICardInstance, _who : ICardInstance) -> void:
	event_type = "KILLED"
	card = _card
	who = _who

func _to_string() -> String:
	return "KilledEvent(%s,%s)" % [card, who]
