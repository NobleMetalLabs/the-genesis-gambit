class_name CustomAction
extends Action

var name : StringName
var data : Dictionary

func _init(_name: StringName, _data: Dictionary) -> void:
	self.name = _name
	self.data = _data