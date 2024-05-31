extends CardLogic

static var description : StringName = "Yep"

func process(_effect_resolver : EffectResolver) -> void:
	for outstanding_effect : Effect in _effect_resolver.effect_queue:
		if outstanding_effect is HandAddCardEffect:
			outstanding_effect = outstanding_effect as HandAddCardEffect
			if outstanding_effect.requester == instance_owner: return
			var new_effect := HandAddCardEffect.new(outstanding_effect.player, outstanding_effect.from_deck, outstanding_effect.specific_card, outstanding_effect.card_metadata_id)
			new_effect.requester = instance_owner
			_effect_resolver.request_effect(new_effect)