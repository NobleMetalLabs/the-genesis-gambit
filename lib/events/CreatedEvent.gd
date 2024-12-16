class_name CreatedEvent
extends Event

var card : ICardInstance
var what : CardMetadata

func _init(_card : ICardInstance, _what : CardMetadata) -> void:
	self.event_type = "CREATED"
	self.card = _card
	self.what = _what

func _to_string() -> String:
	return "CreatedEvent(%s, %s)" % [self.card, self.what]
	

var _resultant_card : ICardInstance

func get_resultant_card() -> ICardInstance:
	return _resultant_card
