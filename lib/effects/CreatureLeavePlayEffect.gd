class_name CreatureLeavePlayEffect
extends CreatureEffect

var source : ICardInstance
var reason : LeavePlayReason
enum LeavePlayReason {
	DIED,
	BANISHED,
}

func _init(_creature : CardOnField, _source : ICardInstance, _reason : LeavePlayReason) -> void:
	self.creature = _creature
	self.source = _source
	self.reason = _reason

func _to_string() -> String:
	return "CreatureLeavePlayEffect(%s,%s,%s)" % [self.creature, self.source, self.reason]