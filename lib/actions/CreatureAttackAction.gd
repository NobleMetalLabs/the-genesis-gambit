class_name CreatureAttackAction
extends CreatureAction

func _init(_creature : CardOnField) -> void:
	self.creature = _creature

func _to_string() -> String:
	return "CreatureAttackAction(%s)" % self.creature