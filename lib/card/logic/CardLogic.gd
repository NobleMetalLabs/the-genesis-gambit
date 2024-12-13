@icon("res://lib/card/logic/CardLogic.png")
class_name CardLogic
extends RefCounted

var game_access : GameAccess
var owner : ICardInstance
var verbose : bool = false

func _init(_owner : ICardInstance, _game_access : GameAccess) -> void:
	owner = _owner
	game_access = _game_access

func _to_string() -> String:
	return "CardLogic(%s)" % [owner]