class_name CommandAction
extends Action

var command_string : String
static func setup(_command_string : String, _gametick : int) -> CommandAction:
	var ca = CommandAction.new()
	ca.command_string = _command_string
	ca.gametick = _gametick
	return ca

func _init() -> void: pass

func _to_string() -> String:
	return "CommandAction(%s)" % [command_string]
