class_name CreatureLeavePlayAction
extends CreatureAction

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
