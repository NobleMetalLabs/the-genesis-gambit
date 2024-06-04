class_name CreatureSpawnEffect
extends CreatureEffect

var position : Vector2

func _init(_creature : CardOnField, _position : Vector2) -> void:
	self.creature = _creature
	self.position = _position

func _to_string() -> String:
	return "CreatureSpawnEffect(%s,%s)" % [self.creature, self.position]

func resolve(effect_resolver : EffectResolver) -> void:
	Router.gamefield.place_card(self.creature, self.position)
	ICardInstance.id(self.creature).player.cards_on_field.append(self.creature)
	if self.requester is Action:
		if Router.client_ui.current_card_ghost != null:
			Router.client_ui.current_card_ghost.queue_free()
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_PLAYED, true)
	var just_played_expire_effect := SetStatisticEffect.new(creature_stats, Genesis.Statistic.WAS_JUST_PLAYED, false)
	just_played_expire_effect.requester = self.requester
	effect_resolver.request_effect(just_played_expire_effect)
	creature_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, true)
