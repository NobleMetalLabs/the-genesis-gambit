extends CardLogic

static var description : StringName = "Targeted creature is inflicted with Sick."

func _set_game_access(_game_access : GameAccess) -> void:
	super(_game_access)
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(owner, "ENTERED_FIELD", owner, ATTEMPT_INSTANT_CAST, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(owner, "TARGETED", owner, ATTEMPT_INSTANT_CAST, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func ATTEMPT_INSTANT_CAST(_event : Event) -> void:
	var my_stats := IStatisticPossessor.id(owner)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
	
	if is_on_field and target != null: INFLICT_WITH_SICK()

func INFLICT_WITH_SICK() -> void:
	game_access.card_processor.request_event(
		GaveMoodEvent.new(owner, IStatisticPossessor.id(owner).get_statistic(Genesis.Statistic.TARGET), StatisticMood.SICK(owner))
	)
	
	game_access.card_processor.request_event(
		KilledEvent.new(owner, owner)
	)
