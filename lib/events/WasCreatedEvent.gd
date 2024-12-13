class_name WasCreatedEvent
extends Event

var card : ICardInstance
var by : ICardInstance

func _init(_card : ICardInstance, _by : ICardInstance = null) -> void:
	self.event_type = "WAS_CREATED"
	self.card = _card
	self.by = _by

func _to_string() -> String:
	return "WasCreatedEvent(%s, %s)" % [self.card, self.by]
		
