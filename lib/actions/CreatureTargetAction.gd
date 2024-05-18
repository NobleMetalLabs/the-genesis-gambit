class_name CreatureTargetAction
extends CreatureAction

var target : ITargetable

func _init(_creature : CardOnField, _target : ITargetable) -> void:
	self.creature = _creature
	self.target = _target

func _to_string() -> String:
	return "CreatureTargetAction(%s,%s)" % [self.creature, self.target]