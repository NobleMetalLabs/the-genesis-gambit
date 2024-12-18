extends CardLogic

static var description : StringName = "Activate: If Flea Market has no charges, a charge from target is transfered to Flea Market. Otherwise, a charge from Flea Market is transfered to target."

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "WAS_ACTIVATED", owner, TRANSFER_CHARGE, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).RARITY_FROM_CARD(owner)
	))

func TRANSFER_CHARGE(_event : WasActivatedEvent) -> void:
	var my_stats := IStatisticPossessor.id(owner)
	var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
	if target == null: return
	
	if IStatisticPossessor.id(owner).get_statistic(Genesis.Statistic.CHARGES) == 0:
		game_access.card_processor.request_event(
			SetStatisticEvent.modify(owner, Genesis.Statistic.CHARGES, 1)
		)
		game_access.card_processor.request_event(
			SetStatisticEvent.modify(target, Genesis.Statistic.CHARGES, -1)
		)
	else:
		game_access.card_processor.request_event(
			SetStatisticEvent.modify(owner, Genesis.Statistic.CHARGES, -1)
		)
		game_access.card_processor.request_event(
			SetStatisticEvent.modify(target, Genesis.Statistic.CHARGES, 1)
		)
