class_name CreatureSpawnEffect
extends CreatureEffect

var position : Vector2

func _init(_creature : CardOnField, _position : Vector2) -> void:
	self.creature = _creature
	self.position = _position

func _to_string() -> String:
	return "CreatureSpawnEffect(%s,%s)" % [self.creature, self.position]

func resolve() -> void:
	Router.gamefield.place_card(self.creature, self.position)
	if self.requester is Action:
		if Router.client_ui.current_card_ghost != null:
			Router.client_ui.current_card_ghost.queue_free()
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_PLAYED, true)
	creature_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, true)
