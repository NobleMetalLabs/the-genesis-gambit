class_name CreatureTargetEffect
extends CreatureEffect

var target : ITargetable

func _init(_creature : CardOnField, _target : ITargetable) -> void:
	self.creature = _creature
	self.target = _target

func _to_string() -> String:
	return "CreatureTargetEffect(%s,%s)" % [self.creature, self.target]