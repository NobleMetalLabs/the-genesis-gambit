extends CardLogic

static var description : StringName = "Each opponent skips their next draw, then draws an additional card the next time they would draw."

var standing_players : Array[Player] = []
var standed_players : Array[Player] = []

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		for player : Player in _backend_objects.players:
			if player != instance_owner.player:
				standing_players.append(player)
	
	for effect : Effect in _effect_resolver.effect_list:
		if not effect is DeckDrawCardEffect: continue
		var draw_effect := effect as DeckDrawCardEffect
		if draw_effect.player in standing_players:
			standed_players.append(draw_effect.player)
			standing_players.erase(draw_effect.player)
			_effect_resolver.remove_effect(draw_effect)
		elif draw_effect.player in standed_players:
			standed_players.erase(draw_effect.player)
			_effect_resolver.request_effect(
				DeckDrawCardEffect.new(
					instance_owner,
					draw_effect.player,
				)
			)
	