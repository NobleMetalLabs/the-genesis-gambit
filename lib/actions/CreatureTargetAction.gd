class_name CreatureTargetAction
extends CreatureAction

var target : ITargetable

static func setup(_creature : ICardInstance, _target : ITargetable) -> CreatureTargetAction:
	var cta := CreatureTargetAction.new()
	cta.creature = _creature
	cta.target = _target
	return cta

func _init() -> void: pass

func _to_string() -> String:
	return "CreatureTargetAction(%s, %s)" % [self.creature, self.target]

func to_effect() -> CreatureTargetEffect:
	return CreatureTargetEffect.new(self, creature, target)