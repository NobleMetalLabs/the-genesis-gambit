class_name EnteredFieldEvent
extends Event

var card : ICardInstance
var keep_stats : bool
var keep_moods : bool

func _init(_card : ICardInstance,  _keep_stats : bool = true, _keep_moods : bool = true) -> void:
	self.card = _card
	self.keep_stats = _keep_stats
	self.keep_moods = _keep_moods

func _to_string() -> String:
	return "EnteredFieldEvent(%s,%s,%s)" % [self.creature, self.keep_stats, self.keep_moods]
