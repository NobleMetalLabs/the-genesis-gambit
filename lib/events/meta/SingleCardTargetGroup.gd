class_name SingleCardTargetGroup
extends BaseTargetGroup

var target : ICardInstance

func _init(_target : ICardInstance) -> void:
	self.target = _target

func get_targets() -> Array[Object]:
	var output : Array[Object] = []
	output.assign([target])
	return output

func _to_string() -> String:
	return "SingleCardTargetGroup[%s]" % target
