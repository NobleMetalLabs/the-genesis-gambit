class_name WasCreatedEvent
extends Event

var card : ICardInstance

func _init(_card : ICardInstance) -> void:
	self.event_type = "WAS_CREATED"
	self.card = _card

func _to_string() -> String:
	return "WasCreatedEvent(%s)" % [self.card]
		
