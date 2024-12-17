class_name SingleCardTargetGroup
extends BaseTargetGroup

var single : ICardInstance

func _init(target : ICardInstance) -> void:
	self.single = target

func does_group_contain(target : Object) -> bool:
	return target == self.single

func _to_string() -> String:
	return "SingleCardTargetGroup[%s]" % single
