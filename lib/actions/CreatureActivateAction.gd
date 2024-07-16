class_name CreatureActivateAction
extends CreatureAction

static func setup(creature : ICardInstance) -> CreatureActivateAction:
	var caa := CreatureActivateAction.new()
	caa.creature_uid = UIDDB.uid(creature)
	return caa

func _init() -> void: pass

func _to_string() -> String:
	return "CreatureActivateAction(%s)" % [UIDDB.object(creature_uid)]

func to_effect() -> CreatureActivateEffect:
	return CreatureActivateEffect.new(self, UIDDB.object(creature_uid))