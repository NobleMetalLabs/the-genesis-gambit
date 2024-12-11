@icon("res://lib/BaseCardLogic.png")
class_name BaseCardLogic
extends RefCounted

var game_access : GameAccess
var owner : ICardInstance
var verbose : bool = false

func _init(_owner : ICardInstance, _game_access : GameAccess) -> void:
	owner = _owner
	game_access = _game_access

func _to_string() -> String:
	return "BaseCardLogic(%s)" % [owner]