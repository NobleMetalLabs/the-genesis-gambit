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
	match event:
		WasCreatedEvent:
			event.card.WAS_CREATED(event)
		EnteredDeckEvent:
			event.card.ENTERED_DECK(event)
		LeftDeckEvent:
			event.card.LEFT_DECK(event)
		EnteredHandEvent:
			event.card.ENTERED_HAND(event)
		LeftHandEvent:
			event.card.LEFT_HAND(event)
		EnteredFieldEvent:
			event.card.ENTERED_FIELD(event)
		LeftFieldEvent:
			event.card.LEFT_FIELD(event)
		WasBurnedEvent:
			event.card.WAS_BURNED(event)
		WasMarkedEvent:
			event.card.WAS_MARKED(event)
		WasUnmarkedEvent:
			event.card.WAS_UNMARKED(event)
		WasDiscardedEvent:
			event.card.WAS_DISCARDED(event)
		AttackedEvent:
			event.card.ATTACKED(event)
		WasAttackedEvent:
			event.card.WAS_ATTACKED(event)
		WasActivatedEvent:
			event.card.WAS_ACTIVATED(event)
		TargetedEvent:
			event.card.TARGETED(event)
		WasTargetedEvent:
			event.card.WAS_TARGETED(event)
		KilledEvent:
			event.card.KILLED(event)
		WasKilledEvent:
			event.card.WAS_KILLED(event)
		GaveMoodEvent:
			event.card.GAVE_MOOD(event)
		GainedMoodEvent:
			event.card.GAINED_MOOD(event)
		TookMoodEvent:
			event.card.TOOK_MOOD(event)
		LostMoodEvent:
			event.card.LOST_MOOD(event)
		PlayedCardEvent:
			event.player.PLAYED_CARD(event)
		BurnedHandEvent:
			event.player.BURNED_HAND(event)
		BeganDeckMaintenanceEvent:
			event.player.BEGAN_DECK_MAINTENANCE(event)
		EndedDeckMaintenanceEvent:
			event.player.ENDED_DECK_MAINTENANCE(event)



# TODO: ER should be able to be queried for all effects that have been relevant to a card, including resolved ones.

# TODO: ER should support effects failing, including cause. This will be really bad for chained effects though, as they will need to be undone?