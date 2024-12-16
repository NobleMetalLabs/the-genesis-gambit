extends CardLogic

static var description : StringName = "Supported creature is covered in ooze. Attacks made against the creature inflict the attacker with slow."

var last_supported_creature : ICardInstance

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "TARGETED", owner, HANDLE_TARGET_DEWATCH, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "SUPPORTED", owner, HANDLE_TARGET_WATCH, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))

func HANDLE_TARGET_DEWATCH(_event : TargetedEvent) -> void:
	if last_supported_creature != null:
		game_access.event_scheduler.unregister_event_processing_steps_by_requester_and_target(owner, last_supported_creature)

func HANDLE_TARGET_WATCH(event : SupportedEvent) -> void:
	last_supported_creature = event.who
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(event.who), "WAS_ATTACKED", owner, INFLICT_SLOW_ON_ATTACKER, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func INFLICT_SLOW_ON_ATTACKER(event : WasAttackedEvent) -> void:
	game_access.card_processor.request_event(
		GaveMoodEvent.new(owner, event.by_who, StatisticMood.SLOW(owner))
	)
