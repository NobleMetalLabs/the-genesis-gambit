extends CardLogic

static var description : StringName = "Gains 1 Happy for each friendly creature tending a Fungus Garden."

func _register_processing_steps() -> void:
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(FriendlyCardsTargetGroup.new(owner.player), "TARGETED", owner, WATCH_TENDING, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

var tenders : Array[ICardInstance] = []

func WATCH_TENDING(event: TargetedEvent) -> void:
	if not game_access.are_two_cards_friendly(owner, event.who): return
	if event.who.metadata.id == CardDB.get_id_by_name("fungus-garden"):
		if tenders.has(event.card): return
		tenders.append(event.card)
		
		game_access.request_event(
			GainedMoodEvent.new(owner, owner, StatisticMood.HAPPY(owner))
			# NOTE: Not sure if GainedMood or GaveMood is preferable here?
		)
	elif tenders.has(event.card):
		tenders.erase(event.card)
		
		game_access.request_event(
			LostMoodEvent.new(owner, owner, StatisticMood.HAPPY(owner))
		)
