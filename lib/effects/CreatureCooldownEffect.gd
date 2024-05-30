class_name CreatureCooldownEffect

var type : CooldownType
enum CooldownType {
	ATTACK,
	ACTIVATE,
}
var stage : CooldownStage
enum CooldownStage {
	START,
	FINISH,
}
var time : int = 0

func _init(_creature : CardOnField, _type : CooldownType, _stage : CooldownStage) -> void:
	self.creature = _creature
	self.type = _type
	self.stage = _stage

func _to_string() -> String:
	return "CreatureCooldownEffect(%s,%s,%s)" % [self.creature, self.type, self.stage]