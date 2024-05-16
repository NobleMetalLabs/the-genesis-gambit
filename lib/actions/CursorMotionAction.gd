class_name CursorMotionAction
extends CursorAction

var position : Vector2

func _init(_player : Player,_position : Vector2) -> void:
	self.player = _player
	self.position = _position

func _to_string() -> String:
	return "CursorMotionAction(%s,%s)" % [self.player, self.position]