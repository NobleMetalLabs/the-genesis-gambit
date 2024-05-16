class_name HandBurnHandAction
extends HandAction

func _init(_player : Player) -> void:
	self.player = _player

func _to_string() -> String:
	return "HandBurnHandAction(%s)" % self.player