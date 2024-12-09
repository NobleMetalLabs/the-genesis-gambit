class_name EndedDeckMaintenanceEvent
extends Event

var player : Player

func _init(_player : Player) -> void:
	self.event_type = "ENDED_DECK_MAINTENANCE"
	self.player = _player

func _to_string() -> String:
	return "EndedDeckMaintenanceEvent(%s)" % self.player