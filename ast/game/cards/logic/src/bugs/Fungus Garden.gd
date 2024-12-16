extends CardLogic

static var description : StringName = "Whenever a creature on your field would be subject to Boredom, it instead targets the Fungus Garden, tending it. Every 5 damage the garden receives gives it a charge of fungus. Activate: Spawn a transient copy of the creature it is targeting."

var damage_count : int = 0

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(AllCardsTargetGroup.new(), "GAINED_MOOD", owner, TARGET_ME_WHEN_BORED, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))
	
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "WAS_ATTACKED", owner, GAIN_CHARGE_EVERY_FIVE_DAMAGE, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))
	
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "WAS_ACTIVATED", owner, DUPE_TARGET, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))

func TARGET_ME_WHEN_BORED(event : GainedMoodEvent) -> void:
	if not game_access.are_two_cards_friendly(event.card, owner): return
	if not event.mood is BoredomMood: return
	
	game_access.card_processor.request_event(
		TargetedEvent.new(event.card, owner)
	)
	event.has_failed = true

func GAIN_CHARGE_EVERY_FIVE_DAMAGE(event : WasAttackedEvent) -> void:
	damage_count += event.damage
	
	var new_charges : int = IStatisticPossessor.id(owner).get_statistic(Genesis.Statistic.CHARGES) + damage_count / 5
	game_access.card_processor.request_event(
		SetStatisticEvent.new(event.card, Genesis.Statistic.CHARGES, new_charges)
	)
	damage_count %= 5
	
	event.damage = 0
	event.has_failed = true

func DUPE_TARGET(_event : WasActivatedEvent) -> void:
	var target : ICardInstance = IStatisticPossessor.id(owner).get_statistic(Genesis.Statistic.TARGET)
	if target == null: return
	
	var dupe_event := CreatedEvent.new(owner, target.metadata)
	game_access.card_processor.request_event(dupe_event)
	var dupe : ICardInstance = dupe_event.get_resultant_card()
	
	game_access.card_processor.request_event(
		EnteredFieldEvent.new(dupe)
	)
	game_access.card_processor.request_event(
		SetStatisticEvent.new(dupe, Genesis.Statistic.IS_TRANSIENT, true)
	)
