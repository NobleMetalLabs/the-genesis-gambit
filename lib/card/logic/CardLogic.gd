@icon("res://lib/card/logic/CardLogic.png")
class_name CardLogic
extends RefCounted

var access_getter : Callable
var game_access : GameAccess: 
	get: return access_getter.call()
var owner : ICardInstance
var verbose : bool = false

func _init(_owner : ICardInstance, _access_getter : Callable) -> void:
	owner = _owner
	access_getter = _access_getter

func _to_string() -> String:
	return "CardLogic(%s)" % [owner]
