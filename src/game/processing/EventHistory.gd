class_name EventHistory
extends RefCounted

var _events_by_gametick : Dictionary = {} # [int, Array[Event]]
var _events_by_card : Dictionary = {} # [ICardInstance, Array[Event]]
var _events_by_card_by_lifetime : Dictionary = {} # [ICardInstance, Array[Array[Event]]]
var _processing_steps_by_event : Dictionary = {} # [Event, Array[EventProcessingStep]]

func clear_events_at_gametick(gametick : int) -> void:
	_events_by_gametick.erase(gametick)

func record_event_at_gametick(event : Event, gametick : int) -> void:
	#print("Recording event %s at gametick %s." % [event, gametick])
	var gametick_events : Array[Event] = []
	gametick_events = _events_by_gametick.get_or_add(gametick, gametick_events)
	gametick_events.append(event)
	var involved_cards : Array[ICardInstance] = []
	involved_cards.assign(Event.get_event_property_names_of_cards(event).map(
		func get_card_from_event(property_name : StringName) -> ICardInstance:
			return event.get(property_name)
	))
	for card : ICardInstance in involved_cards:
		if card == null: continue
		_record_event_for_card(event, card)

func _record_event_for_card(event : Event, card : ICardInstance) -> void:
	#print("Recording event %s for card %s." % [event, card])
	var card_events : Array[Event] = []
	card_events = _events_by_card.get_or_add(card, card_events)
	card_events.append(event)

	var card_events_by_lifetime : Array[Array] = []
	card_events_by_lifetime = _events_by_card_by_lifetime.get_or_add(card, card_events_by_lifetime)
	var card_lifetime_events : Array[Event] = []
	var existing : Variant = card_events_by_lifetime.pop_back()
	if existing: card_lifetime_events.assign(existing)
	card_lifetime_events.append(event)
	card_events_by_lifetime.append(card_lifetime_events)

func record_processing_steps_for_event(event : Event, processing_steps : Array[EventProcessingStep]) -> void:
	_processing_steps_by_event[event] = processing_steps

func get_events_at_gametick(gametick : int) -> Array[Event]:
	var gametick_events : Array[Event] = []
	gametick_events.assign(_events_by_gametick.get(gametick, gametick_events))
	return gametick_events

func get_processing_steps_for_event(event : Event) -> Array[EventProcessingStep]:
	var processing_steps : Array[EventProcessingStep] = []
	processing_steps.assign(_processing_steps_by_event.get(event, processing_steps))
	return processing_steps

func get_events_by_card(card : ICardInstance) -> Array[Event]:
	var card_events : Array[Event] = []
	card_events.assign(_events_by_card.get(card, card_events))
	return card_events

func report_card_lifetime_end(card : ICardInstance) -> void:
	pass
