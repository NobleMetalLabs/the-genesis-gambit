class_name EventScheduler
extends RefCounted

var event_history : EventHistory
var processing_steps_by_event_type : Dictionary = {} #[StringName, Array[EventProcessingStep]]
var processing_step_by_requester : Dictionary = {} #[Object, Array[EventProcessingStep]]

func _init(_event_history : EventHistory) -> void:
	self.event_history = _event_history

func _get_processing_steps_by_event_type(event_type : StringName) -> Array[EventProcessingStep]:
	var processing_steps : Array[EventProcessingStep] = []
	processing_steps.assign(processing_steps_by_event_type.get(event_type, []))
	return processing_steps

func _get_processing_steps_by_requester(requester : Object) -> Array[EventProcessingStep]:
	var processing_steps : Array[EventProcessingStep] = []
	processing_steps.assign(processing_step_by_requester.get(requester, []))
	return processing_steps

func register_event_processing_step(event_processing_step : EventProcessingStep) -> void:
	_register_bulk([event_processing_step])

func _register_bulk(event_processing_steps : Array[EventProcessingStep]) -> void:
	for event_processing_step in event_processing_steps:
		var registered_steps : Array[EventProcessingStep] = []
		registered_steps = processing_steps_by_event_type.get_or_add(event_processing_step.event_type, registered_steps)

		var already_registered : bool = false
		for registered_step : EventProcessingStep in registered_steps:
			if registered_step._equals(event_processing_step):
				already_registered = true
				break
		if not already_registered:
			registered_steps.append(event_processing_step)
			processing_step_by_requester.get_or_add(event_processing_step.processing_source, []).append(event_processing_step)
		else:
			print("WARNING: %s is already registered." % [event_processing_step])

func unregister_event_processing_steps_by_requester(requester : Object) -> void:
	_unregister_bulk(_get_processing_steps_by_requester(requester))

func unregister_event_processing_steps_by_requester_and_target(requester : Object, target : Object) -> void:
	var processing_steps : Array[EventProcessingStep] = _get_processing_steps_by_requester(requester)

	_unregister_bulk(processing_steps.filter(
		func is_target_group_object(event_processing_step : EventProcessingStep) -> bool:
			if event_processing_step.target_group is AllCardsTargetGroup:
				return true
			elif event_processing_step.target_group is SingleCardTargetGroup:
				return event_processing_step.target_group.does_group_contain(target)
			else:
				return false
	))

func _unregister_bulk(event_processing_steps : Array[EventProcessingStep]) -> void:
	for event_processing_step in event_processing_steps:
		processing_steps_by_event_type[event_processing_step.event_type].erase(event_processing_step)

# IMPORTANT: NOTHING SHOULD EVER BE ADDED TO THIS FUNCTION. INSTEAD, IT SHOULD BE A PROCESSING STEP
func process_event(event : Event) -> void:
	event_history._signal_begin_processing_event(event)
	var processing_steps : Array[EventProcessingStep] = _get_processing_steps_for_event(event)
	for processing_step in processing_steps:
		if processing_step.priority.to_int() <= EventPriority.new().INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MAX).to_int():
			if event.has_failed: continue
		event_history._signal_begin_processing_step(processing_step)
		processing_step.function.call(event)
		event_history._signal_end_processing_step()
	event_history._signal_end_processing_event()

func _get_processing_steps_for_event(event : Event) -> Array[EventProcessingStep]:
	var steps_for_target : Array[EventProcessingStep] = []
	steps_for_target.assign(_get_processing_steps_by_event_type(event.event_type).filter(
		func is_target_in_processing_step_targetgroup(event_processing_step : EventProcessingStep) -> bool:
			return event_processing_step.target_group.does_group_contain(event.get_subject())
	))

	steps_for_target.sort_custom(func sort_by_priority_int_descending(a : EventProcessingStep, b : EventProcessingStep) -> bool:
		return a.priority.to_int() > b.priority.to_int()
	)
	return steps_for_target
	
