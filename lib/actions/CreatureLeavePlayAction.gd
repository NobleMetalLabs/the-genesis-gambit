class_name CreatureLeavePlayAction
extends CreatureAction

var source : ICardInstance
var reason : LeavePlayReason
enum LeavePlayReason {
	DIED,
	BANISHED,
}