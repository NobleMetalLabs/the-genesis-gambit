extends CardLogic

static var description : StringName = "When Mother Spider dies, add three transient Spiders to your hand."

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(owner), "WAS_KILLED", owner, ADD_THREE_SPIDERS, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func ADD_THREE_SPIDERS(_event: WasKilledEvent) -> void:
	for i in range(3):
		var spider_event := CreatedEvent.new(owner, CardDB.get_card_by_name("spider"))
		game_access.card_processor.request_event(spider_event)
		var spider : ICardInstance = spider_event.get_resultant_card()
		
		game_access.card_processor.request_event(
			EnteredHandEvent.new(spider)
		)
		game_access.card_processor.request_event(
			SetStatisticEvent.new(spider, Genesis.Statistic.IS_TRANSIENT, true)
		)
