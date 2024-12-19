extends CardLogic

static var description : StringName = "Supported creature gains 2 Angry."

var last_supported_creature : ICardInstance

func _register_processing_steps() -> void:
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "TARGETED", owner, HANDLE_TARGET_DEWATCH, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "SUPPORTED", owner, ADD_STRENGTH_TO_SUPPORTED,
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))

func HANDLE_TARGET_DEWATCH(_event : TargetedEvent) -> void:
	if last_supported_creature != null:
		game_access.request_event(
			TookMoodEvent.new(owner, last_supported_creature, StatisticMood.ANGRY(owner, 2))
		)

func ADD_STRENGTH_TO_SUPPORTED(event : SupportedEvent) -> void:
	last_supported_creature = event.who
	
	game_access.request_event(
		GaveMoodEvent.new(owner, last_supported_creature, StatisticMood.ANGRY(owner, 2))
	)
