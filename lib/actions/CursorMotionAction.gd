class_name CursorMotionAction
extends CursorAction

var position : Vector2

static func setup(_position : Vector2) -> CursorMotionAction:
	var cma := CursorMotionAction.new()
	cma.position = _position
	return cma

func _to_string() -> String:
	return "CursorMotionAction(%s,%s)" % [self.player, self.position]