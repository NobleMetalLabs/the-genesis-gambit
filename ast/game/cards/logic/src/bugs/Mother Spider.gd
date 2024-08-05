extends CardLogic

static var description : StringName = "When Mother Spider dies, add three Spiders to your hand."

# doesnt work because the card is dead before process catches it
# changing "WAS JUST KILLED" to HEALTH <= 0 fixes this (but is kinda cringe) 
# but the hand add effects dont work either anyway
# i think because the requester which is this is dead? idk lol

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_KILLED):
		for i in range(3):
			_effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					instance_owner.player,
					Router.backend.create_card(
						CardDB.get_id_by_name("Spider"),
						instance_owner.player,
						"MotherSpider-Spider-%s-%s" % [AuthoritySourceProvider.authority_source.current_frame_number, i]
					)
				)
			)
