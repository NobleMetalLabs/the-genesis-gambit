extends CardLogic

static var description : StringName = "When making an attack against a support creature, Vausp deals 1 extra damage."

var standing_players : Array[Player] = []
var standed_players : Array[Player] = []

func process(gamefield_state : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		for player : Player in gamefield_state.players:
			if player != instance_owner.player:
				standing_players.append(player)
	
	for effect : Effect in effect_resolver.effect_list:
		if not effect is HandAddCardEffect: continue
		var draw_effect := effect as HandAddCardEffect
		if draw_effect.player in standing_players:
			standed_players.append(draw_effect.player)
			standing_players.erase(draw_effect.player)
			effect_resolver.remove_effect(draw_effect)
		elif draw_effect.player in standed_players:
			standed_players.erase(draw_effect.player)
			effect_resolver.request_effect(draw_effect)
	