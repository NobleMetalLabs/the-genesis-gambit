class_name EventScheduler
extends Node

var processing_steps_by_event_by_target : Dictionary = {} #[ICardInstance, Dictionary[StringName, Array[EventProcessingStep]]]
var processing_step_by_requester : Dictionary = {} #[ICardInstance, Array[EventProcessingStep]]

func register_event_processing_step(event_processing_step : EventProcessingStep) -> void:
	_register_bulk([event_processing_step])

func _register_bulk(event_processing_steps : Array[EventProcessingStep]) -> void:
	for event_processing_step in event_processing_steps:
		var target_event_processing_steps : Dictionary = processing_steps_by_event_by_target.get(event_processing_step.target, {})
		target_event_processing_steps.get_or_add(event_processing_step.event_type, []).append(event_processing_step)
		processing_step_by_requester.get_or_add(event_processing_step.processing_source, []).append(event_processing_step)
		# TODO: check for dupe

# Requests targeting unknowns or groups
#func register_event_processing_step(target_schema : TargetSchema, event_type, function : Callable) -> void:

func process_event(event : Event) -> void:
	var processing_steps : Array[EventProcessingStep] = processing_steps_by_event_by_target.get(event.target, {}).get(event.event_type, [])
	processing_steps.sort_custom(func sort_by_priority_int_descending(a : EventProcessingStep, b : EventProcessingStep) -> bool:
		return a.priority.to_int() > b.priority.to_int()
	)
	for processing_step in processing_steps:
		processing_step.function.call(event)
	