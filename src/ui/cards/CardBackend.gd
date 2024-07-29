class_name CardBackend
extends Node

func _init(ci : ICardInstance) -> void:
	self.add_child(ci)
	var stats := IStatisticPossessor.new()
	stats.set_statistic(Genesis.Statistic.HEALTH, ci.metadata.health)
	stats.set_statistic(Genesis.Statistic.STRENGTH, ci.metadata.strength)
	stats.set_statistic(Genesis.Statistic.SPEED, ci.metadata.speed)
	stats.set_statistic(Genesis.Statistic.ENERGY, ci.metadata.energy)
	self.add_child(stats)
	self.add_child(IMoodPossessor.new())

	self.name = self._to_string()

func _to_string() -> String:
	return "CardBackend<%s>" % ICardInstance.id(self)
