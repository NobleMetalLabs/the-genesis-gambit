extends CardLogic

static var description : StringName = "Each friendly Damage card gains Boredom."

var friendly_damage : Array[ICardInstance] = []

func _register_processing_steps() -> void:
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(AllCardsTargetGroup.new(), "ENTERED_FIELD", owner, WATCH_DAMAGE, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(owner), "ENTERED_FIELD", owner, DAMAGE_GETS_BORED, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func WATCH_DAMAGE(event: EnteredFieldEvent) -> void:
	if event.card.metadata.type != Genesis.CardType.ATTACKER: return # NOTE: lol
	if not game_access.are_two_cards_friendly(owner, event.card): return
	friendly_damage.append(event.card)
	
	game_access.epsm.register_event_processing_step(
		EventProcessingStep.new(SingleCardTargetGroup.new(event.card), "LEFT_FIELD", owner, DEWATCH_DAMAGE, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func DEWATCH_DAMAGE(event: LeftFieldEvent) -> void:
	friendly_damage.erase(event.card)

func DAMAGE_GETS_BORED(_event: EnteredFieldEvent) -> void:
	for damage : ICardInstance in friendly_damage:
		game_access.request_event(
			GaveMoodEvent.new(owner, damage, BoredomMood.new(owner))
		)
	
	game_access.request_event(
		KilledEvent.new(owner, owner)
	)
