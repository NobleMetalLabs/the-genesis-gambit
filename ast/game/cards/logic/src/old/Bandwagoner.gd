extends CardLogic

static var description : StringName = "Whenever a friendly creature attacks, this creature attacks the same target."

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	if not instance_owner.get_object() is CardOnField: return
	
	var my_stats := IStatisticPossessor.id(instance_owner)
	var friendly_cards : Array[ICardInstance] = []
	friendly_cards = _gamefield_state.cards.filter(func(c : ICardInstance) -> bool: return c.player == _gamefield_state.get_player_from_instance(instance_owner))

	for effect in _effect_resolver.effect_list:
		if not effect is CreatureAttackEffect: continue
		effect = effect as CreatureAttackEffect
		if effect.requester in friendly_cards:
			_effect_resolver.request_effect(CreatureAttackEffect.new(
				instance_owner,
				instance_owner.get_object(), 
				effect.target, 
				my_stats.get_statistic(Genesis.Statistic.STRENGTH)
			))
