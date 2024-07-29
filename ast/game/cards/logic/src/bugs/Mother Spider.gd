extends CardLogic

static var description : StringName = "When Mother Spider dies, add three Spiders to your hand."

func process(_backend_state : MatchBackendState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_DIED):
		for i in range(3):
			_effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					_backend_state.get_player_from_instance(instance_owner),
					Router.backend.create_card(
						CardDB.get_id_by_name("Spider"),
						instance_owner.player,
						"MotherSpider-Spider-%s-%s" % [AuthoritySourceProvider.authority_source.current_frame_number, i]
					)
				)
			)