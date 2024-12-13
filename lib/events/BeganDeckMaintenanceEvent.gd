class_name BeganDeckMaintenanceEvent
extends Event

var player : Player

func _init(_player : Player) -> void:
	self.event_type = "BEGAN_DECK_MAINTENANCE"
	self.player = _player

func _to_string() -> String:
	return "BeganDeckMaintenanceEvent(%s)" % self.player