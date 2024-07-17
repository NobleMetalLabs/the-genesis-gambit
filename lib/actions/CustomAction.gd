class_name CustomAction
extends Action

var name : StringName
var data : Dictionary

static func setup(_name: StringName, _data: Dictionary) -> CustomAction:
	var ca := CustomAction.new()
	ca.name = _name
	ca.data = _data
	return ca