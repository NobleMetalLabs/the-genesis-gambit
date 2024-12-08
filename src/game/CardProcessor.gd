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
	if event is AttackedEvent:
		event.card.logic.ATTACKED.emit(event)
	elif event is BeganDeckMaintenanceEvent:
		event.player.BEGAN_DECK_MAINTENANCE.emit(event)
	elif event is BurnedHandEvent:
		event.player.BURNED_HAND.emit(event)
	elif event is EndedDeckMaintenanceEvent:
		event.player.ENDED_DECK_MAINTENANCE.emit(event)
	elif event is EnteredDeckEvent:
		event.card.logic.ENTERED_DECK.emit(event)
	elif event is EnteredHandEvent:
		event.card.logic.ENTERED_HAND.emit(event)
	elif event is EnteredFieldEvent:
		event.card.logic.ENTERED_FIELD.emit(event)
	elif event is GainedMoodEvent:
		event.card.logic.GAINED_MOOD.emit(event)
	elif event is GaveMoodEvent:
		event.card.logic.GAVE_MOOD.emit(event)
	elif event is KilledEvent:
		event.card.logic.KILLED.emit(event)
	elif event is LeftDeckEvent:
		event.card.logic.LEFT_DECK.emit(event)
	elif event is LeftHandEvent:
		event.card.logic.LEFT_HAND.emit(event)
	elif event is LeftFieldEvent:
		event.card.logic.LEFT_FIELD.emit(event)
	elif event is LostMoodEvent:
		event.card.logic.LOST_MOOD.emit(event)
	elif event is PlayedCardEvent:
		event.player.PLAYED_CARD.emit(event)
	elif event is SupportedEvent:
		event.card.logic.SUPPORTED.emit(event)
	elif event is TargetedEvent:
		event.card.logic.TARGETED.emit(event)
	elif event is TookMoodEvent:
		event.card.logic.TOOK_MOOD.emit(event)
	elif event is WasActivatedEvent:
		event.card.logic.WAS_ACTIVATED.emit(event)
	elif event is WasAttackedEvent:
		event.card.logic.WAS_ATTACKED.emit(event)
	elif event is WasBurnedEvent:
		event.card.logic.WAS_BURNED.emit(event)
	elif event is WasCreatedEvent:
		event.card.logic.WAS_CREATED.emit(event)
	elif event is WasDiscardedEvent:
		event.card.logic.WAS_DISCARDED.emit(event)
	elif event is WasKilledEvent:
		event.card.logic.WAS_KILLED.emit(event)
	elif event is WasMarkedEvent:
		event.card.logic.WAS_MARKED.emit(event)
	elif event is WasTargetedEvent:
		event.card.logic.WAS_TARGETED.emit(event)
	elif event is WasUnmarkedEvent:
		event.card.logic.WAS_UNMARKED.emit(event)



# TODO: ER should be able to be queried for all effects that have been relevant to a card, including resolved ones.

# TODO: ER should support effects failing, including cause. This will be really bad for chained effects though, as they will need to be undone?
