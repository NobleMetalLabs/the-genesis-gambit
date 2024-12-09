class_name EventProcessingStep
extends RefCounted

var target : ICardInstance # Should be a variant or sum ish. Maybe even a class for advanced targetting
var event_type : StringName
var processing_source : Object
var function : Callable
var priority : EventPriority

func _init(_target : ICardInstance, _event_type : StringName, _processing_source : Object, _function : Callable, _priority : EventPriority) -> void:
	self.target = _target
	self.event_type = _event_type
	self.processing_source = _processing_source
	self.function = _function
	self.priority = _priority

func _to_string() -> String:
	return "EventPStep(%s::%s, {%s::%s, %s})" % [self.target, self.event_type, self.processing_source, self.function.get_method(), self.priority.to_int()]

func _equals(other : EventProcessingStep) -> bool:
	if self.target != other.target: return false
	if self.event_type != other.event_type: return false
	if self.processing_source != other.processing_source: return false
	if self.function != other.function: return false
	if self.priority.to_int() != other.priority.to_int(): return false
	return true