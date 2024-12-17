class_name GameAccessManager
extends RefCounted

var _game_access_by_gametick : Dictionary = {} # [int, GameAccess]
var _current_gametick : int = 0

func _init() -> void:
	_game_access_by_gametick[0] = GameAccess.new(CardProcessor.new())

func get_current_game_access() -> GameAccess:
	return _game_access_by_gametick.get(_current_gametick, null)

func advance_gametick() -> void:
	var current_access : GameAccess = get_current_game_access()
	_current_gametick += 1
	_game_access_by_gametick[_current_gametick] = current_access.duplicate()

func revert_to_gametick(gametick : int) -> void:
	for i in range(_current_gametick, gametick, -1):
		_game_access_by_gametick.erase(i)
	_current_gametick = gametick