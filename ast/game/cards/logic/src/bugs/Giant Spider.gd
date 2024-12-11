extends CardLogic

static var description : StringName = "When Giant Spider damages an attacker, that attacker receives Slow."

func _set_game_access(_game_access : GameAccess) -> void:
	super(_game_access)
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(owner), "ATTACKED", owner, ADD_SLOW_TO_TARGET_IF_ATTACKER, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func ADD_SLOW_TO_TARGET_IF_ATTACKER(event: AttackedEvent) -> void:
	if event.who.metadata.type == Genesis.CardType.ATTACKER:
		game_access.card_processor.request_event(
			GaveMoodEvent.new(owner, event.who, StatisticMood.SLOW(owner))
		)
