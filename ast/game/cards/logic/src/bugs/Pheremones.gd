extends CardLogic

static var description : StringName = "Each Attacker you control gains Boredom."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD) == false: return
	if my_stats.get_cooldown_of_type(Genesis.CooldownType.SSICKNESS) != null: return
	
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
	
	_effect_resolver.request_effect(
		CreatureLeavePlayEffect.new(
			instance_owner,
			instance_owner,
			instance_owner,
			Genesis.LeavePlayReason.SPENT
		)
	)
