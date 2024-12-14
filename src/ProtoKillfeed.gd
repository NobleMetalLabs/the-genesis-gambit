class_name Protokillfeed
extends TextEdit

@onready var sandbox : Sandbox = get_node("../".repeat(5))
@onready var history : EventHistory = sandbox.processor.event_history

func _ready() -> void:
	sandbox.processor.finished_processing_events.connect(update_text)

func update_text() -> void:
	self.text = ""
	var events : Array[Event] = history.get_events_at_gametick(0)
	var event_groups : Dictionary = create_event_groups(events)

	var event_pairs : Dictionary = {}
	for event_group : Array[Event] in event_groups.values():
		event_pairs.merge(analyze_event_group(event_group))

	var event_kfitems : Dictionary = {} # [Event, KillFeedItem]
	for event : Event in event_pairs.keys():
		var event2 : Event = event_pairs[event]
		event_kfitems[event] = KillFeedItem.FROM_EVENT_PAIR(event, event2)

	var total_kfitems : Array[KillFeedItem] = []
	for event : Event in event_kfitems.keys():
		total_kfitems.append(_return_kfitem_with_ancestry(event_kfitems[event], event))

	for kfitem in total_kfitems: _print_kfitem(kfitem)

func _print_kfitem(kfitem : KillFeedItem, indent : int = 0) -> void:
	self.text += "\t".repeat(indent) + kfitem.content + "\n"
	for child in kfitem.child_items:
		_print_kfitem(child, indent + 1)

func _return_kfitem_with_ancestry(descendant : KillFeedItem, event : Event) -> KillFeedItem:
	var proc_record : EventProcessingRecord = history.get_event_processing_record(event)
	var parent_event : Event = proc_record.caused_by_event
	if parent_event == null: return descendant
	return _return_kfitem_with_ancestry(KillFeedItem.FROM_EVENT(parent_event).WITH_CHILDREN([descendant]), proc_record.caused_by_event)

func create_event_groups(events : Array[Event]) -> Dictionary:
	var event_groups : Dictionary = {} #[Event, Array[Event]]
	var already_grouped_events : Array[Event] = []
	for event in events:
		_create_event_groups(event, event_groups, already_grouped_events)
	return event_groups

func _create_event_groups(event : Event, event_groups : Dictionary, already_grouped_events : Array[Event]) -> void:
	if event in already_grouped_events: return
	var proc_record : EventProcessingRecord = history.get_event_processing_record(event)
	var event_group : Array[Event] = []
	event_groups.get_or_add(proc_record.caused_by_event, event_group).append(event)
	already_grouped_events.append(event)
	for caused_events in proc_record.caused_events:
		_create_event_groups(caused_events, event_groups, already_grouped_events)

func analyze_event_group(events : Array[Event]) -> Dictionary:
	var already_paired_events : Array[Event] = []
	var event_pairs : Dictionary = {} # [Event, Event]
	for event_idx in range(events.size()):
		var event : Event = events[event_idx]
		if event in already_paired_events: continue
		var possible_pairs : Array[Array] = _find_possible_pair_events(event, events.slice(event_idx))
		if possible_pairs.size() > 0:
			var pair : Array = possible_pairs.pop_front()
			event_pairs[pair[0]] = pair[1]
			already_paired_events.append(pair[0])
			already_paired_events.append(pair[1])
	return event_pairs

func _find_possible_pair_events(subject_event : Event, other_events : Array[Event]) -> Array[Array]:
	var event_pairs : Array[Array] = [] # Array[Array[Event]]
	for event in other_events:
		if event == subject_event: continue
		if _are_events_pairable(subject_event, event):
			event_pairs.append([subject_event, event])
	return event_pairs

func _are_events_pairable(event1 : Event, event2 : Event) -> bool:
	match([event1.event_type, event2.event_type]):
		["CREATED", "ENTERED_HAND"]:
			var was_created_e : WasCreatedEvent
			var es : Array = history.get_event_processing_record(event1).caused_events.filter(
				func is_was_created_event(e : Event) -> bool: return e is WasCreatedEvent
			)
			if es.size() > 1: 
				push_error("MAN!")
			was_created_e = es.pop_front()
			return was_created_e.card == event2.card
		_: 
			return false