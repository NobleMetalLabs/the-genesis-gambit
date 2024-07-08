class_name CreatureActivateAction
extends CreatureAction

static func setup(_creature : ICardInstance) -> CreatureActivateAction:
	var caa := CreatureActivateAction.new()
	caa.creature = _creature
	return caa

func _init() -> void: pass

func _to_string() -> String:
	return "CreatureActivateAction(%s, %s)" % [self.player, self.creature]

func to_effect() -> CreatureActivateEffect:
	return CreatureActivateEffect.new(self, creature)