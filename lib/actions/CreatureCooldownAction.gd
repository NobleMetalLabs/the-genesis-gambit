class_name CreatureCooldownAction
extends CreatureAction

var type : Genesis.CooldownType
var stage : Genesis.CooldownStage
var frames : int = 0

func _init(_creature : ICardInstance, _type : Genesis.CooldownType, _stage : Genesis.CooldownStage, _frames : int = 0) -> void:
	self.creature = _creature
	self.type = _type
	self.stage = _stage
	self.frames = _frames

func _to_string() -> String:
	return "CreatureCooldownAction(%s,%s,%s)" % [self.creature, self.type, self.stage]

func to_effect() -> CreatureCooldownEffect:
	return CreatureCooldownEffect.new(self, creature, type, stage, frames)