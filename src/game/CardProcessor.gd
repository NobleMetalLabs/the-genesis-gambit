class_name CardProcessor
extends RefCounted

var requested_events : Array[Event] = []
func request_event(_event : Event) -> void:
	#requested_events.append(_event)
	process_event(_event)

func process_events() -> void:
	for event : Event in requested_events:
		process_event(event)
	requested_events.clear()

func process_event(event : Event) -> void:
	print("Processing event: %s" % [event])
	if event is WasCreatedEvent:
		event.card.WAS_CREATED(event)
	elif event is EnteredDeckEvent:
		event.card.ENTERED_DECK(event)
	elif event is LeftDeckEvent:
		event.card.LEFT_DECK(event)
	elif event is EnteredHandEvent:
		event.card.ENTERED_HAND(event)
	elif event is LeftHandEvent:
		event.card.LEFT_HAND(event)
	elif event is EnteredFieldEvent:
		event.card.logic.ENTERED_FIELD(event)
	elif event is LeftFieldEvent:
		event.card.LEFT_FIELD(event)
	elif event is WasBurnedEvent:
		event.card.WAS_BURNED(event)
	elif event is WasMarkedEvent:
		event.card.WAS_MARKED(event)
	elif event is WasUnmarkedEvent:
		event.card.WAS_UNMARKED(event)
	elif event is WasDiscardedEvent:
		event.card.WAS_DISCARDED(event)
	elif event is AttackedEvent:
		event.card.ATTACKED(event)
	elif event is WasAttackedEvent:
		event.card.WAS_ATTACKED(event)
	elif event is WasActivatedEvent:
		event.card.WAS_ACTIVATED(event)
	elif event is TargetedEvent:
		event.card.TARGETED(event)
	elif event is WasTargetedEvent:
		event.card.WAS_TARGETED(event)
	elif event is KilledEvent:
		event.card.KILLED(event)
	elif event is WasKilledEvent:
		event.card.WAS_KILLED(event)
	elif event is GaveMoodEvent:
		event.card.GAVE_MOOD(event)
	elif event is GainedMoodEvent:
		event.card.GAINED_MOOD(event)
	elif event is TookMoodEvent:
		event.card.TOOK_MOOD(event)
	elif event is LostMoodEvent:
		event.card.LOST_MOOD(event)
	elif event is PlayedCardEvent:
		event.player.PLAYED_CARD(event)
	elif event is BurnedHandEvent:
		event.player.BURNED_HAND(event)
	elif event is BeganDeckMaintenanceEvent:
		event.player.BEGAN_DECK_MAINTENANCE(event)
	elif event is EndedDeckMaintenanceEvent:
		event.player.ENDED_DECK_MAINTENANCE(event)



# TODO: ER should be able to be queried for all effects that have been relevant to a card, including resolved ones.

# TODO: ER should support effects failing, including cause. This will be really bad for chained effects though, as they will need to be undone?