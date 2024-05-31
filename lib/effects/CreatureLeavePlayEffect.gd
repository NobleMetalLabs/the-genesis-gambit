class_name CreatureLeavePlayEffect
extends CreatureEffect

var source : ICardInstance
var reason : CreatureLeavePlayAction.LeavePlayReason

func _init(_creature : CardOnField, _source : ICardInstance, _reason : CreatureLeavePlayAction.LeavePlayReason) -> void:
	self.creature = _creature
	self.source = _source
	self.reason = _reason

func _to_string() -> String:
	return "CreatureLeavePlayEffect(%s,%s,%s)" % [self.creature, self.source, self.reason]