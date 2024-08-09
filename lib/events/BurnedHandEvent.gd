class_name BurnedHandEvent
extends Event

var player : Player

func _init(_player : Player) -> void:
	self.player = _player

func _to_string() -> String:
	return "BurnedHandEvent(%s)" % self.player