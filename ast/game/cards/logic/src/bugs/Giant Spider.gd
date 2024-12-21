extends CardLogic

static var description : StringName = "When Giant Spider damages an attacker, that attacker receives Slow."

func _register_processing_steps() -> void:
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "ATTACKED", owner, ADD_SLOW_TO_TARGET_IF_ATTACKER, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func ADD_SLOW_TO_TARGET_IF_ATTACKER(event: AttackedEvent) -> void:
	if event.who.metadata.type == Genesis.CardType.ATTACKER:
		game_access.request_event(
			GaveMoodEvent.new(owner, event.who, StatisticMood.SLOW(owner))
		)
