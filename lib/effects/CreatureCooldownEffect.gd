class_name CreatureCooldownEffect

var type : CreatureCooldownAction.CooldownType
var stage : CreatureCooldownAction.CooldownStage
var time : int = 0

func _init(_creature : CardOnField, _type : CreatureCooldownAction.CooldownType, _stage : CreatureCooldownAction.CooldownStage) -> void:
	self.creature = _creature
	self.type = _type
	self.stage = _stage

func _to_string() -> String:
	return "CreatureCooldownEffect(%s,%s,%s)" % [self.creature, self.type, self.stage]