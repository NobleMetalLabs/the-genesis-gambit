class_name PlayedCardEvent
extends Event

var player : Player
var card : ICardInstance

func _init(_player : Player, _card : ICardInstance) -> void:
	self.player = _player
	self.card = _card

func _to_string() -> String:
	return "PlayedCardEvent(%s, %s)" % [self.player, self.card]