class_name CreatureActivateEffect
extends CreatureEffect

func _init(_creature : CardOnField) -> void:
	self.creature = _creature

func _to_string() -> String:
	return "CreatureActivateEffect(%s)" % self.creature

func resolve() -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED, true)
	var flash_tween : Tween = Router.get_tree().create_tween()
	flash_tween.tween_property(self.creature, "modulate", Color(1, 0, 0, 1), 0)
	flash_tween.tween_property(self.creature, "modulate", Color(1, 1, 1, 1), 0.5)