extends CardLogic

static var description : StringName = "Each Attacker you control becomes Bored."

var fungus_garden : ICardInstance = null

func process(_backend_state : MatchBackendState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if not my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	for card : ICardInstance in _backend_state.get_player_from_instance(instance_owner).cards_on_field:
		if not card: continue
		if card.type != Genesis.CardType.ATTACKER: continue
		_effect_resolver.request_effect(
			ApplyMoodEffect.new(
				instance_owner,
				IMoodPossessor.id(card),
				BoredomMood.new(instance_owner),
			)
		)