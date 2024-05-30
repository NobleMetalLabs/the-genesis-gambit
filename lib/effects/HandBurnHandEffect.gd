class_name HandBurnHandEffect
extends HandEffect

func _init(_player : Player) -> void:
	self.player = _player

func _to_string() -> String:
	return "HandBurnHandEffect(%s)" % self.player