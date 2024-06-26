class_name CreatureLeavePlayAction
extends CreatureAction

var source : ICardInstance
var reason : Genesis.LeavePlayReason

func _init(_creature : ICardInstance, _source : ICardInstance, _reason : Genesis.LeavePlayReason) -> void:
	self.creature = _creature
	self.source = _source
	self.reason = _reason

func _to_string() -> String:
	return "CreatureLeavePlayAction(%s,%s,%s)" % [self.creature, self.source, self.reason]

func to_effect() -> CreatureLeavePlayEffect:
	return CreatureLeavePlayEffect.new(self, creature, source, reason)