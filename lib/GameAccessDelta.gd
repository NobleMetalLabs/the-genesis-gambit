class_name GameAccessDelta
extends RefCounted

var new_processing_steps : Array[EventProcessingStep] = []
var removed_processing_steps : Array[EventProcessingStep] = []

var changed_local_properties : Array[Dictionary] = [] # {object, property, old, new}
var changed_statistics : Array[Dictionary] = [] # {IStatisticPossessor, Genesis.Statistic, old, new}
