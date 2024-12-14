class_name EventProcessingRecord 
extends RefCounted

var gametick : int
var event : Event
var processing_steps : Array[EventProcessingStep]
var caused_by_event : Event
var caused_events : Array[Event]
var caused_events_by_processing_step : Dictionary

func _init(_gametick : int, _event : Event, _caused_by : Event) -> void:
	gametick = _gametick
	event = _event
	caused_by_event = _caused_by
	processing_steps = []
	caused_events = []
	caused_events_by_processing_step = {}

func add_processing_step(processing_step : EventProcessingStep) -> void:
	processing_steps.append(processing_step)
	var empty : Array[Event] = []
	caused_events_by_processing_step[processing_step] = empty

func add_caused_event(caused_event : Event, processing_step : EventProcessingStep) -> void:
	caused_events.append(caused_event)
	caused_events_by_processing_step[processing_step].append(caused_event)
