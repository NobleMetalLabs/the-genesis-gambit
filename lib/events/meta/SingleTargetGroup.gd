class_name SingleTargetGroup
extends BaseTargetGroup

var target : ICardInstance

func _init(_target : ICardInstance) -> void:
	self.target = _target

func get_targets() -> Array[ICardInstance]:
	var output : Array[ICardInstance] = []
	output.assign([target])
	
	return output

func _to_string() -> String:
	return "SingleTargetGroup[%s]" % target
