class_name CursorGrabAction
extends CursorAction

var item : IGrabbable
var grabbed : bool

static func setup(_item : IGrabbable, _grabbed : bool) -> CursorGrabAction:
	var cga := CursorGrabAction.new()
	cga.item = _item
	cga.grabbed = _grabbed
	return cga

func _init() -> void: pass

func _to_string() -> String:
	return "CursorGrabAction(%s,%s,%s)" % [self.player_peer_id, self.item, self.grabbed]