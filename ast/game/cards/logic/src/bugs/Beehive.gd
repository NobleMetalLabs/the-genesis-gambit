extends CardLogic

static var description : StringName = "Beehive acts as a Blocker. Add a Bee to your hand every 20 seconds. When an attacker with more than three power damages Beehive, add a Bee to your hand "

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		my_stats.set_statistic(Genesis.Statistic.ACTS_AS_BLOCKER, true)
	
	# TODO: Not summoning bee on timer rn.
	for effect in _effect_resolver.effect_list:
		if not effect is CreatureAttackEffect: continue
		effect = effect as CreatureAttackEffect
		if not effect.target == instance_owner: continue
		if effect.damage > 3:
			_effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					instance_owner.player,
					Router.backend.create_card(
						CardDB.get_id_by_name("Bee"),
						instance_owner.player,
						"Beehive-Bee-%s" % [Router.backend.get_created_card_number()]
					)
				)
			)
