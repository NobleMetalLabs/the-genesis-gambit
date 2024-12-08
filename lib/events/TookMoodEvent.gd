class_name TookMoodEvent
extends Event

var card : ICardInstance
var who : ICardInstance
var mood : Mood

func _init(_card : ICardInstance, _who : ICardInstance, _mood : Mood) -> void:
	self.card = _card
	self.who = _who
	self.mood = _mood

func _to_string() -> String:
	return "TookMoodEvent(%s, %s, %s)" % [self.card, self.who, self.mood]
