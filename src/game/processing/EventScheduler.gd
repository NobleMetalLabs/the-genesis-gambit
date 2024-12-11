class_name EventScheduler
extends Node

var event_causality : EventCausalityLogger
var event_history : EventHistory
var processing_steps_by_event_by_target : Dictionary = {} #[ICardInstance, Dictionary[StringName, Array[EventProcessingStep]]]
var processing_step_by_requester : Dictionary = {} #[ICardInstance, Array[EventProcessingStep]]
var processing_steps_by_event_all_target : Dictionary = {} #[StringName, Array[EventProcessingStep]] # TODO: bad hack, can't scale

func _init(_event_causality : EventCausalityLogger, _event_history : EventHistory) -> void:
	self.event_causality = _event_causality
	self.event_history = _event_history

func register_event_processing_step(event_processing_step : EventProcessingStep) -> void:
	_register_bulk([event_processing_step])

func _register_bulk(event_processing_steps : Array[EventProcessingStep]) -> void:
	for event_processing_step in event_processing_steps:
		var registered_steps : Array[EventProcessingStep] = []
		if event_processing_step.target_group is AllCardsTargetGroup:
			registered_steps = processing_steps_by_event_all_target.get_or_add(event_processing_step.event_type, registered_steps)
		else:
			var targets : Array[ICardInstance] = event_processing_step.target_group.get_targets()
			
			for target : ICardInstance in targets:
				var target_event_processing_steps : Dictionary = processing_steps_by_event_by_target.get_or_add(target, {})
				registered_steps = target_event_processing_steps.get_or_add(event_processing_step.event_type, registered_steps)
		
		var already_registered : bool = false
		for registered_step : EventProcessingStep in registered_steps:
			if registered_step._equals(event_processing_step):
				already_registered = true
				break
		if not already_registered:
			registered_steps.append(event_processing_step)
			processing_step_by_requester.get_or_add(event_processing_step.processing_source, []).append(event_processing_step)
			print("%s registered." % [event_processing_step])
		else:
			print("WARNING: %s is already registered." % [event_processing_step])

func unregister_event_processing_steps_by_requester(requester : ICardInstance) -> void:
	_unregister_bulk(processing_step_by_requester.get(requester, []))

func unregister_event_processing_steps_by_requester_and_target(requester : ICardInstance, target : ICardInstance) -> void:
	_unregister_bulk(processing_step_by_requester.get(requester, []).filter(
		func _filter_steps_for_same_target(event_processing_step : EventProcessingStep) -> bool:
			return event_processing_step.target == target
	))

func _unregister_bulk(event_processing_steps : Array[EventProcessingStep]) -> void:
	for event_processing_step in event_processing_steps:
		processing_steps_by_event_by_target[event_processing_step.target][event_processing_step.event_type].erase(event_processing_step)

var _currently_processing_events_stack : Array[Event] = []
# IMPORTANT: NOTHING SHOULD EVER BE ADDED TO THIS FUNCTION. INSTEAD, IT SHOULD BE A PROCESSING STEP
func process_event(event : Event) -> void:
	_currently_processing_events_stack.push_back(event)
	for processing_step in _get_processing_steps_for_event(event):
		print("  -{%s::%s}" % [processing_step.processing_source, processing_step.function.get_method()])
		processing_step.function.call(event)
	var finished_event : Event = _currently_processing_events_stack.pop_back()
	# TODO: shit below needs to be a processing step ie undoable
	var parent_event : Event = _currently_processing_events_stack.pop_back()
	if parent_event != null:
		event_causality.register_caused_event(parent_event, event)
		_currently_processing_events_stack.push_back(parent_event)
	event_history.record_event_at_gametick(event, 0)
	# ^*

func _get_processing_steps_for_event(event : Event) -> Array[EventProcessingStep]:
	var processing_steps : Array[EventProcessingStep] = []

	var steps_for_target : Array[EventProcessingStep] = []
	steps_for_target.assign(processing_steps_by_event_by_target.get(event.card, {}).get(event.event_type, []))
	processing_steps.append_array(steps_for_target)

	var steps_no_target : Array[EventProcessingStep] = []
	steps_no_target.assign(processing_steps_by_event_all_target.get(event.event_type, []))
	processing_steps.append_array(steps_no_target)

	processing_steps.sort_custom(func sort_by_priority_int_descending(a : EventProcessingStep, b : EventProcessingStep) -> bool:
		return a.priority.to_int() > b.priority.to_int()
	)
	print("%s processing steps collated for event." % [processing_steps.size()])
	return processing_steps
	
