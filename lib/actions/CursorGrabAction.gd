class_name CursorGrabAction
extends CursorAction

var item #: IGrabbable
var grabbed : bool = false

func _init(_player : Player, item, grabbed : bool) -> void: #: IGrabbable
	self.player = _player
	self.item = item

func _to_string() -> String:
	return "CursorGrabAction(%s,%s,%s)" % [self.player, self.item, self.grabbed]