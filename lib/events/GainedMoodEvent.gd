class_name GainedMoodEvent
extends Event

var card : ICardInstance
var from : ICardInstance
var mood : Mood

func _init(_card : ICardInstance, _from : ICardInstance, _mood : Mood) -> void:
	self.event_type = "GAINED_MOOD"
	self.card = _card
	self.from = _from
	self.mood = _mood

func _to_string() -> String:
	return "GainedMoodEvent(%s, %s, %s)" % [self.card, self.from, self.mood]