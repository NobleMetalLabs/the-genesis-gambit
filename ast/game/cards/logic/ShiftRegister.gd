extends CardLogic

static var description : StringName = "Yep"

func process(_effect_resolver : EffectResolver) -> void:
	for outstanding_effect : Effect in _effect_resolver.effect_queue:
		if outstanding_effect is HandAddCardEffect:
			print("ShiftRegister's cardlogic reacted to the player drawing a card.")