class_name EventProcessingStep
extends RefCounted

var target_group : BaseTargetGroup
var event_type : StringName
var processing_source : Object
var function : Callable
var priority : EventPriority

func _init(_target_group : BaseTargetGroup, _event_type : StringName, _processing_source : Object, _function : Callable, _priority : EventPriority) -> void:
	self.target_group = _target_group
	self.event_type = _event_type
	self.processing_source = _processing_source
	self.function = _function
	self.priority = _priority

func _to_string() -> String:
	return "EventPStep(%s::%s, {%s::%s, %s})" % [self.target_group, self.event_type, self.processing_source, self.function.get_method(), self.priority.to_int()]

func _equals(other : EventProcessingStep) -> bool:
	if self.target_group != other.target_group: return false
	if self.event_type != other.event_type: return false
	if self.processing_source != other.processing_source: return false
	if self.function != other.function: return false
	if self.priority.to_int() != other.priority.to_int(): return false
	return true
