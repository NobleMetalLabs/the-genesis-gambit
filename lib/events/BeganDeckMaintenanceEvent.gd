class_name BeganDeckMaintenanceEvent
extends Event

var player : Player

func _init(_player : Player) -> void:
	self.player = _player

func _to_string() -> String:
	return "BeganDeckMaintenanceEvent(%s)" % self.player