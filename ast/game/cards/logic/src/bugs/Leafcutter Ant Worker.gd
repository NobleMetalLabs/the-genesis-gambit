extends CardLogic

static var description : StringName = "Whenever a friendly Fungus Garden gains a charge, heal 1 health."

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(AllCardsTargetGroup.new(), "ENTERED_FIELD", owner, WATCH_FUNGUS_GARDENS, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func WATCH_FUNGUS_GARDENS(event: EnteredFieldEvent) -> void:
	if event.card.metadata.id != CardDB.get_id_by_name("fungus-garden"): return
	if not game_access.are_two_cards_friendly(owner, event.card): return
	game_access.event_scheduler.register_event_processing_step(
	EventProcessingStep.new(SingleCardTargetGroup.new(event.card), "SET_STATISTIC", owner, GAIN_HEALTH_ON_FUNGUS_CHARGE, 
		EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.event_scheduler.register_event_processing_step(
	EventProcessingStep.new(SingleCardTargetGroup.new(event.card), "LEFT_FIELD", owner, DEWATCH_FUNGUS_GARDEN, 
		EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func GAIN_HEALTH_ON_FUNGUS_CHARGE(event: SetStatisticEvent) -> void: 
	if not event.statistic == Genesis.Statistic.CHARGES: return
	var charge_delta : int = event.new_value - event.old_value
	if charge_delta <= 0: return
	
	game_access.card_processor.request_event(
		SetStatisticEvent.new(owner, Genesis.Statistic.HEALTH, charge_delta)
	)

func DEWATCH_FUNGUS_GARDEN(event: LeftFieldEvent) -> void:
	game_access.event_scheduler.unregister_event_processing_steps_by_requester_and_target(owner, event.card)
