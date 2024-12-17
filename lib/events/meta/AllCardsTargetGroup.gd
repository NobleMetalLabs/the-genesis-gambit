class_name AllCardsTargetGroup
extends BaseTargetGroup

func does_group_contain(target : Object) -> bool:
	if target is ICardInstance:
		return true
	return false

func _to_string() -> String:
	return "AllCardsTargetGroup"
