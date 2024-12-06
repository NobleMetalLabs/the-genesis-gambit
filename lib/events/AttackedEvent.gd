class_name AttackedEvent
extends Event

var card : ICardInstance
var who : ICardInstance
var damage : int

func _init(_card : ICardInstance, _who : ICardInstance, _damage : int) -> void:
	self.card = _card
	self.who = _who
	self.damage = _damage

func _to_string() -> String:
	return "AttackedEvent(%s, %s, %s)" % [self.card, self.who, self.damage]
		
