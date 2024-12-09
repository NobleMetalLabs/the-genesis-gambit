class_name EventProcessingStep
extends RefCounted

var target : ICardInstance
var event_type : StringName
var processing_source : ICardInstance
var function : Callable
var priority : EventPriority

func _init(_target : ICardInstance, _event_type : StringName, _processing_source : ICardInstance, _function : Callable, _priority : EventPriority) -> void:
	self.target = _target
	self.event_type = _event_type
	self.processing_source = _processing_source
	self.function = _function
	self.priority = _priority

func _to_string() -> String:
	return "EventPStep(%s::%s, {%s::%s, %s})" % [self.target, self.event_type, self.processing_source, self.function.get_method(), self.priority.to_int()]