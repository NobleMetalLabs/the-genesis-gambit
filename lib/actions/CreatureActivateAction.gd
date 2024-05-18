class_name CreatureActivateAction
extends CreatureAction

func _init(_creature : CardOnField) -> void:
	self.creature = _creature

func _to_string() -> String:
	return "CreatureActivateAction(%s)" % self.creature