class_name CreatureTargetAction
extends CreatureAction

var target_uid : int

static func setup(creature : ICardInstance, target : ICardInstance) -> CreatureTargetAction:
	var cta := CreatureTargetAction.new()
	cta.creature_uid = UIDDB.uid(creature)
	if target == null:
		cta.target_uid = -1
	else:
		cta.target_uid = UIDDB.uid(target)
	return cta

func _init() -> void: pass

func _to_string() -> String:
	if target_uid == -1:
		return "CreatureTargetAction(%s, null)" % [UIDDB.object(creature_uid)]
	return "CreatureTargetAction(%s, %s)" % [UIDDB.object(creature_uid), UIDDB.object(target_uid)]

# func to_effect() -> CreatureTargetEffect:
# 	if target_uid == -1:
# 		return CreatureTargetEffect.new(self, UIDDB.object(creature_uid), null)
# 	return CreatureTargetEffect.new(self, UIDDB.object(creature_uid), UIDDB.object(target_uid))
