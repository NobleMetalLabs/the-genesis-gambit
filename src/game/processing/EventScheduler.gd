class_name EventScheduler
extends RefCounted

var event_history := EventHistory.new()
var processing_steps_by_event_type : Dictionary = {} #[StringName, Array[EventProcessingStep]]
var processing_step_by_requester : Dictionary = {} #[Object, Array[EventProcessingStep]]

func _to_string() -> String:
	return "ES(%s, %s)" % [hash(self), event_history]

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
	save_requester_property_values(event, processing_steps)
	
	for processing_step in processing_steps:
		if processing_step.priority.to_int() <= EventPriority.new().INDIVIDUAL(EventPriority.PROCESSING_INDIVIDUAL_MAX).to_int():
			if event.has_failed: continue
		event_history._signal_begin_processing_step(processing_step)
		processing_step.function.call(event)
		event_history._signal_end_processing_step()
	
	identify_changed_properties(event)
	event_history._signal_end_processing_event()

var saved_object_values_by_object_by_event : Dictionary
var changed_local_properties : Array[Dictionary] = []

func save_requester_property_values(event : Event, steps : Array[EventProcessingStep]) -> void:
	for processing_step : EventProcessingStep in steps:
		var requester : Object = processing_step.processing_source
		var property_list : Array[Dictionary] = requester.get_property_list()
		var script_variables : Array[Dictionary] = property_list.filter(func get_script_variables(p : Dictionary) -> bool: return p["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE)
		var variable_names : Array[String] = []
		variable_names.assign(script_variables.map(func(p : Dictionary) -> String: return p.name))
		
		var requester_properties : Dictionary
		for var_name in variable_names: 
			var var_value : Variant = requester.get(var_name)
			if var_value is Array or var_value is Dictionary: var_value = var_value.duplicate()
			requester_properties[var_name] = var_value
		
		saved_object_values_by_object_by_event.get_or_add(event, {})[requester] = requester_properties
	
	#print(JSON.stringify(saved_object_values_by_object_by_event))

func identify_changed_properties(event : Event) -> void:
	var relevant_obj_dict : Dictionary = saved_object_values_by_object_by_event[event]
	
	for object : Object in relevant_obj_dict:
		var property_dict : Dictionary = relevant_obj_dict[object]
		for property : StringName in property_dict:
			if property_dict[property] != object.get(property):
				var record_dict : Dictionary = {
					"object": object,
					"property": property,
					"old_value": property_dict[property],
					"new_value": object.get(property)
				}
				print(record_dict)
				changed_local_properties.append(record_dict)

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
	
