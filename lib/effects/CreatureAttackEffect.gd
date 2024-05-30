class_name CreatureAttackEffect
extends CreatureEffect

func _init(_creature : CardOnField) -> void:
	self.creature = _creature

func _to_string() -> String:
	return "CreatureAttackEffect(%s)" % self.creature