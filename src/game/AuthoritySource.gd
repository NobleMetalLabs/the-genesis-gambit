class_name AuthoritySource
extends Node

signal reflect_action(action : Action)
signal reflect_gamestate(gamestate : MatchBackendState)

func request_action(action : Action) -> void:
	assert(false, "Abstract function 'request_action()' not implemented by" % [self])
	action.is_empty()

# very funny function to suppress warnings about the abstract signals not being used
func ε() -> void:
	reflect_action.emit(null)
	reflect_gamestate.emit(null)
