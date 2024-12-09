class_name CustomEvent
extends Event

var name : StringName
var data : Dictionary

func _init(_name: StringName, _data: Dictionary) -> void:
	self.event_type = "CUSTOM"
	self.name = _name
	self.data = _data