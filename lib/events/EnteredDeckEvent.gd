class_name EnteredDeckEvent
extends Event

var card : ICardInstance
var keep_stats : bool
var keep_moods : bool
var at_index : int

func _init(_card : ICardInstance, _keep_stats : bool = false, _keep_moods : bool = false, _at_index : int = 999) -> void:
	self.event_type = "ENTERED_DECK"
	self.card = _card
	self.keep_stats = _keep_stats
	self.keep_moods = _keep_moods
	self.at_index = _at_index
	
func _to_string() -> String:
	return "EnteredDeckEvent(%s,%s,%s,%d)" % [self.card, self.keep_stats, self.keep_moods, self.at_index]
