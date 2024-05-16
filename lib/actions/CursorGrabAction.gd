class_name CursorGrabAction
extends CursorAction

var item #: IGrabbable
var grabbed = false

func _init(item ) -> void: #: IGrabbable
	self.item = item