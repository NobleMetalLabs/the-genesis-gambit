class_name CardProcessor
extends RefCounted

var event_scheduler : EventScheduler = EventScheduler.new()
var requested_events : Array[Event] = []
func request_event(_event : Event) -> void:
	#requested_events.append(_event)
	process_event(_event)

func process_events() -> void:
	for event : Event in requested_events:
		process_event(event)
	requested_events.clear()

func process_event(event : Event) -> void:
	print("PROCESSING EVENT: %s" % [event])
	event_scheduler.process_event(event)

# TODO: ER should be able to be queried for all effects that have been relevant to a card, including resolved ones.

# TODO: ER should support effects failing, including cause. This will be really bad for chained effects though, as they will need to be undone?
