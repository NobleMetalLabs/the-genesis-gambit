extends CardLogic

static var description : StringName = "Each first attack made by a creature against Moth deals no damage."

var has_been_attacked_by : Array[ICardInstance] = []

func _register_processing_steps() -> void:
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(owner), "WAS_CREATED", owner, HANDLE_WAS_CREATED, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(owner), "WAS_ATTACKED", owner, PREVENT_FIRST_ATTACK_FROM_UNIQUE_ATTACKER, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))

func HANDLE_WAS_CREATED(_event : WasCreatedEvent) -> void:
	has_been_attacked_by.clear()

func PREVENT_FIRST_ATTACK_FROM_UNIQUE_ATTACKER(event : WasAttackedEvent) -> void:
	if not has_been_attacked_by.has(event.by_who):
		event.damage = 0
		has_been_attacked_by.append(event.by_who)
