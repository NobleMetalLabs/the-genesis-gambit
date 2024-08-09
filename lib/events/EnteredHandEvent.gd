class_name EnteredHandEvent
extends Event

var card : ICardInstance

func _init(_card : ICardInstance) -> void:
	self.card = _card

func _to_string() -> String:
	return "EnteredHandEvent(%s,%s)" % [self.player, self.card]
	