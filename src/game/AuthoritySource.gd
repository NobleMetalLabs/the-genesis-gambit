class_name AuthoritySource
extends Node

signal reflect_action(action : Dictionary)
signal reflect_gamestate(gamestate : Dictionary)

func request_action(action : Dictionary) -> void:
	assert(false, "Abstract function 'request_action()' not implemented by" % [self])
	action.is_empty()
