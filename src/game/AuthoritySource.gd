class_name AuthoritySource
extends Node

signal reflect_action(action : Action)
signal reflect_gamestate(gamestate : GamefieldState)

func request_action(action : Action) -> void:
	assert(false, "Abstract function 'request_action()' not implemented by" % [self])
	action.is_empty()
