extends CardLogic

static var description : StringName = "Targeted creature is attacked for 2 damage."

func _register_processing_steps() -> void:
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "ENTERED_FIELD", owner, ATTEMPT_INSTANT_CAST, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "TARGETED", owner, ATTEMPT_INSTANT_CAST, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func ATTEMPT_INSTANT_CAST(_event : Event) -> void:
	var my_stats := IStatisticPossessor.id(owner)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
	
	if is_on_field and target != null: ATTACK_FOR_TWO_DAMAGE()

func ATTACK_FOR_TWO_DAMAGE() -> void:
	game_access.request_event(
		AttackedEvent.new(owner, IStatisticPossessor.id(owner).get_statistic(Genesis.Statistic.TARGET), 2)
	)
	
	game_access.request_event(
		KilledEvent.new(owner, owner)
	)
