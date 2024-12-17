class_name BaseTargetGroup
extends RefCounted

func does_group_contain(_target : Object) -> bool:
	assert(false, "'does_group_contain()' called on TargetGroup that does not implement it.")
	return false
