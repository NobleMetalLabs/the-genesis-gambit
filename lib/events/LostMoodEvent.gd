class_name LostMoodEvent
extends Event

var card : ICardInstance
var by : ICardInstance
var mood : Mood

func _init(_card : ICardInstance, _by : ICardInstance, _mood : Mood) -> void:
	self.card = _card
	self.by = _by
	self.mood = _mood

func _to_string() -> String:
	return "LostMoodEvent(%s, %s, %s)" % [self.card, self.by, self.mood]
