extends CardLogic

static var description : StringName = "Supported creature is protected. Attacks made against the creature deal half damage."

var last_supported_creature : ICardInstance

func _set_game_access(_game_access : GameAccess) -> void:
	super(_game_access)
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(owner), "TARGETED", owner, HANDLE_TARGET_DEWATCH, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(owner), "SUPPORTED", owner, HANDLE_TARGET_WATCH, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.PREEVENT).RARITY_FROM_CARD(owner)
	))

func HANDLE_TARGET_DEWATCH(_event : TargetedEvent) -> void:
	if last_supported_creature != null:
		game_access.event_scheduler.unregister_event_processing_steps_by_requester_and_target(owner, last_supported_creature)

func HANDLE_TARGET_WATCH(event : SupportedEvent) -> void:
	last_supported_creature = event.who
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(SingleTargetGroup.new(event.who), "WAS_ATTACKED", owner, MODIFY_DAMAGE_OF_ATTACK_ON_PROTECTED, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.EVENT).RARITY_FROM_CARD(owner)
	))

func MODIFY_DAMAGE_OF_ATTACK_ON_PROTECTED(event : WasAttackedEvent) -> void:
	event.damage /= 2

#extends CardLogic
#
#static var description : StringName = "Targeted creature is protected. Attacks made against the creature deal half damage."
#
#func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	#var my_stats := IStatisticPossessor.id(instance_owner)
	#if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		#var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		#if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
			#for effect in _effect_resolver.effect_list:
				#if not effect is CreatureAttackEffect: continue
				#effect = effect as CreatureAttackEffect
				#if not effect.target == target: continue
				#effect.damage = effect.damage / 2
