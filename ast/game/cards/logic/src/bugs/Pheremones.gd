extends CardLogic

static var description : StringName = "Each Attacker you control becomes Bored."

var fungus_garden : ICardInstance = null

# TODO: Crashes sometimes when played
func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if not my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): return
	for card : ICardInstance in instance_owner.player.cards_on_field:
		if not card: continue
		if card.metadata.type != Genesis.CardType.ATTACKER: continue
		_effect_resolver.request_effect(
			ApplyMoodEffect.new(
				instance_owner,
				IMoodPossessor.id(card),
				BoredomMood.new(instance_owner),
			)
		)
