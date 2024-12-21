class_name GameAccessDelta
extends RefCounted

var new_processing_steps : Array[EventProcessingStep] = []
var removed_processing_steps : Array[EventProcessingStep] = []

var changed_local_properties : Array[Dictionary] = [] # {object, property, old, new}
var changed_statistics : Array[Dictionary] = [] # {IStatisticPossessor, Genesis.Statistic, old, new}

func is_empty() -> bool:
	return new_processing_steps.is_empty() \
	and removed_processing_steps.is_empty() \
	and changed_local_properties.is_empty() \
	and changed_statistics.is_empty()

func _to_string() -> String:
	return "GameAccessDelta(\n%s\n%s\n%s\n%s\n)" \
	% [new_processing_steps, removed_processing_steps, changed_local_properties, changed_statistics]
