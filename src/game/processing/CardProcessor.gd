class_name CardProcessor
extends RefCounted

var event_scheduler : EventScheduler = EventScheduler.new()
var event_history : EventHistory : 
	get:
		return event_scheduler.event_history

func _init() -> void:
	event_history._signal_begin_gametick(0) # TODO: bad hack 7

var requested_events : Array[Event] = []
func request_event(_event : Event) -> void:
	if currently_processing_events:
		process_event(_event)
	else:
		requested_events.append(_event)

signal finished_processing_events
var currently_processing_events : bool = true #false DEBUG
func process_events() -> void:
	currently_processing_events = true
	#event_history._signal_begin_gametick(0)
	for event : Event in requested_events:
		process_event(event)
	requested_events.clear()
	currently_processing_events = false
	#event_history._signal_end_gametick()
	finished_processing_events.emit()

func process_event(event : Event) -> void:
	event_scheduler.process_event(event)
	finished_processing_events.emit() # TODO: bad hack

func duplicate() -> CardProcessor:
	var ep_dupe : EventScheduler = event_scheduler.duplicate()
	var eh_dupe : EventHistory = event_history.duplicate()
	var dupe := CardProcessor.new()
	dupe.event_scheduler = ep_dupe
	dupe.event_history = eh_dupe
	return dupe

func _to_string() -> String: return "CardProcessor"
