class_name BaseTargetGroup
extends RefCounted

func get_targets() -> Array[ICardInstance]:
	assert(false, "'get_targets()' called on TargetGroup that does not implement it.")
	return []
