class_name HandRemoveCardAction
extends HandAction

var card : CardInHand
var leave_reason : LeaveReason
enum LeaveReason {
	PLAYED,
	DISCARDED,
	BANISHED,
}
var animation : CardRemoveAnimation
enum CardRemoveAnimation {
	PLAY,
	DISCARD,
	BURN,
	BANISH,
}