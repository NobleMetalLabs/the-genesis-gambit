class_name CardProcessor
extends RefCounted

var event_causality : EventCausalityLogger = EventCausalityLogger.new()
var event_history : EventHistory = EventHistory.new()
var event_scheduler : EventScheduler = EventScheduler.new(event_causality, event_history)

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
	for event : Event in requested_events:
		process_event(event)
	requested_events.clear()
	currently_processing_events = false
	finished_processing_events.emit()

func process_event(event : Event) -> void:
	print("PROCESSING EVENT: %s" % [event])
	event_scheduler.process_event(event)
	finished_processing_events.emit() # TODO: bad hack

# TODO: ER should support effects failing, including cause. This will be really bad for chained effects though, as they will need to be undone?

func _to_string() -> String: return "CardProcessor"