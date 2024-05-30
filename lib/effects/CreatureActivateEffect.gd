class_name CreatureActivateEffect
extends CreatureEffect

func _init(_creature : CardOnField) -> void:
	self.creature = _creature

func _to_string() -> String:
	return "CreatureActivateEffect(%s)" % self.creature