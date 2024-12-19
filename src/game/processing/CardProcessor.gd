class_name CardProcessor
extends RefCounted

var event_scheduler : EventScheduler = EventScheduler.new()
var event_history : EventHistory : 
	get:
		return event_scheduler.event_history

func _init() -> void:
	event_history.set_current_gametick(0) # TODO: bad hack 7

var requested_events : Array[Event] = []
func request_event(_event : Event) -> void:
	if currently_processing_events:
		process_event(_event)
	else:
		requested_events.append(_event)

var currently_processing_events : bool = true #false DEBUG
func process_events() -> void:
	currently_processing_events = true
	for event : Event in requested_events:
		process_event(event)
	requested_events.clear()
	
	var new_delta = GameAccessDelta.new()
	new_delta.changed_local_properties = event_scheduler.changed_local_properties
	
	currently_processing_events = false

func process_event(event : Event) -> void:
	event_scheduler.process_event(event)

func _to_string() -> String: return "EP(%s, %s)" % [hash(self), event_scheduler]
