extends CardLogic

static var description : StringName = "When Weevil enters the field, create a transient, inert Weevil in your hand."

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(owner), "ENTERED_FIELD", owner, ADD_WEEVIL, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func ADD_WEEVIL(_event: EnteredFieldEvent) -> void:
	var inert_weevil_md : CardMetadata = CardDB.get_card_by_name("weevil").duplicate()
	inert_weevil_md.rarity = Genesis.CardRarity.COMMON
	inert_weevil_md.logic_script = CardMetadata.nothing_script
	
	var weevil_event := CreatedEvent.new(owner, inert_weevil_md)
	game_access.card_processor.request_event(weevil_event)
	var inert_weevil : ICardInstance = weevil_event.get_resultant_card()

	game_access.card_processor.request_event(
		EnteredHandEvent.new(inert_weevil)
	)
	game_access.card_processor.request_event(
		SetStatisticEvent.new(inert_weevil, Genesis.Statistic.IS_TRANSIENT, true)
	)
