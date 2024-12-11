class_name EventCausalityLogger
extends RefCounted

var event_causalities : Array[EventCausality] = []
var event_to_causalities : Dictionary = {} # [Event, EventCausality]

func register_event(event : Event) -> void:
	var event_causality : EventCausality = _get_or_make_causality(event)
	event_causality.event = event
	self.event_causalities.append(event_causality)
	self.event_to_causalities[event] = event_causality

func register_caused_event(event : Event, caused_event : Event) -> void:
	var event_causality : EventCausality = _get_or_make_causality(event)
	var caused_event_causality : EventCausality = _get_or_make_causality(caused_event)
	event_causality.add_caused_event(caused_event_causality)
	caused_event_causality.add_caused_by_event(event_causality)

func get_events_caused_by(event : Event) -> Array[Event]:
	var event_causality : EventCausality = _get_or_make_causality(event)
	var caused_events : Array[Event] = [] 
	caused_events.assign(event_causality.caused_events.map(
		func extract_event(caused_event_causality : EventCausality) -> Event:
			return caused_event_causality.event
	))
	return caused_events

func get_events_which_caused(event : Event) -> Array[Event]:
	var event_causality : EventCausality = _get_or_make_causality(event)
	var caused_by_events : Array[Event] = [] 
	caused_by_events.assign(event_causality.caused_by_events.map(
		func extract_event(caused_by_event_causality : EventCausality) -> Event:
			return caused_by_event_causality.event
	))
	return caused_by_events

func _get_or_make_causality(event : Event) -> EventCausality:
	if self.event_to_causalities.has(event):
		return self.event_to_causalities[event]
	else:
		var event_causality := EventCausality.new()
		event_causality.event = event
		self.event_causalities.append(event_causality)
		self.event_to_causalities[event] = event_causality
		return event_causality

class EventCausality extends RefCounted:
	var event : Event
	var caused_events : Array[EventCausality]
	var caused_by_events : Array[EventCausality]

	func add_caused_event(event_causality : EventCausality) -> void:
		caused_events.append(event_causality)

	func add_caused_by_event(event_causality : EventCausality) -> void:
		caused_by_events.append(event_causality)
	
	func _to_string() -> String:
		return "EventCausality<%s>" % event
