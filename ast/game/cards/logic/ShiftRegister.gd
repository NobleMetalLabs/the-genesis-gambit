extends CardLogic

static var description : StringName = "Yep"

func process(_effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var is_in_hand : bool = my_stats.get_statistic(Genesis.Statistic.IS_IN_HAND)
	if not is_in_hand: return
	for outstanding_effect : Effect in _effect_resolver.effect_list:
		if outstanding_effect is HandAddCardEffect:
			print("HandAddCardEffect detected in effect queue")
			outstanding_effect = outstanding_effect as HandAddCardEffect
			if outstanding_effect.requester == instance_owner: 
				print("Requester is instance owner, returning")
				return
			print("Requester is not instance owner, creating new effect")
			var new_effect := HandAddCardEffect.new(outstanding_effect.player, outstanding_effect.from_deck, outstanding_effect.specific_card, outstanding_effect.card_metadata_id)
			new_effect.requester = instance_owner
			_effect_resolver.request_effect(new_effect)
