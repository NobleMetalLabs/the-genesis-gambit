class_name WasAttackedEvent
extends Event

var card : ICardInstance
var by_who : ICardInstance
var damage : int

func _init(_card : ICardInstance, _by_who : ICardInstance, _damage : int) -> void:
	self.event_type = "WAS_ATTACKED"
	self.card = _card
	self.by_who = _by_who
	self.damage = _damage

func _to_string() -> String:
	return "WasAttackedEvent(%s, %s, %s)" % [self.card, self.by_who, self.damage]
		
