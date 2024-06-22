class_name Effect
extends RefCounted

var requester : Object

var resolve_status : ResolveStatus
enum ResolveStatus {
	REQUESTED,
	AWAITING,
	RESOLVED,
	DONE,
	FAILED, #TODO: Allow effects to fail resolution.
}

func _init() -> void:
	assert(false, "Effect is an abstract class and should not be instantiated.")

