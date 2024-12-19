extends CardLogic

static var description : StringName = "On kill: Friendly Fungus Gardens gain 1 charge."

var fungus_gardens : Array[ICardInstance] = []

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(AllCardsTargetGroup.new(), "ENTERED_FIELD", owner, WATCH_FUNGUS_GARDENS, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.event_scheduler.register_event_processing_step(
	EventProcessingStep.new(SingleCardTargetGroup.new(owner), "KILLED", owner, GIVE_CHARGE_TO_GARDENS, 
		EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func WATCH_FUNGUS_GARDENS(event: EnteredFieldEvent) -> void:
	if event.card.metadata.id != CardDB.get_id_by_name("fungus-garden"): return
	if not game_access.are_two_cards_friendly(owner, event.card): return
	fungus_gardens.append(event.card)
	
	game_access.event_scheduler.register_event_processing_step(
	EventProcessingStep.new(SingleCardTargetGroup.new(event.card), "LEFT_FIELD", owner, DEWATCH_FUNGUS_GARDEN, 
		EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func GIVE_CHARGE_TO_GARDENS(_event: KilledEvent) -> void: 
	for fungus_garden : ICardInstance in fungus_gardens:
		game_access.card_processor.request_event(
			SetStatisticEvent.modify(fungus_garden, Genesis.Statistic.CHARGES, 1)
		)

func DEWATCH_FUNGUS_GARDEN(event: LeftFieldEvent) -> void:
	fungus_gardens.erase(event.card)
