extends CardLogic

static var description : StringName = "When Mother Spider dies, add three Spiders to your hand."

func _set_game_access(_game_access : GameAccess) -> void:
	super(_game_access)
	game_access.event_scheduler.register_event_processing_step(
		EventProcessingStep.new(owner, "WAS_KILLED", owner, ADD_THREE_SPIDERS, 
			EventPriority.new().STAGE(EventPriority.PROCESSING_STAGE.POSTEVENT).RARITY_FROM_CARD(owner)
	))

func ADD_THREE_SPIDERS(_event: WasKilledEvent) -> void:
	for i in range(3):
		game_access.card_processor.request_event(
			CreatedEvent.new(owner, CardDB.get_card_by_name("spider"))
		)
		

#func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	#var my_stats := IStatisticPossessor.id(instance_owner)
	#if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_KILLED):
		#for i in range(3):
			#_effect_resolver.request_effect(
				#HandAddCardEffect.new(
					#instance_owner,
					#instance_owner.player,
					#Router.backend.create_card(
						#CardDB.get_id_by_name("Spider"),
						#instance_owner.player,
						#"MotherSpider-Spider-%s-%s" % [AuthoritySourceProvider.authority_source.current_frame_number, i]
					#)
				#)
			#)
