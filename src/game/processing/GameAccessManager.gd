class_name GameAccessManager
extends RefCounted

var _game_access_by_gametick : Dictionary = {} # [int, GameAccess]
var _current_gametick : int = 0

signal advanced_to_new_gametick(gametick : int)

func _init() -> void:
	_game_access_by_gametick[0] = GameAccess.new()

func get_current_game_access() -> GameAccess:
	print(_game_access_by_gametick)
	return _game_access_by_gametick.get(_current_gametick, null)

func advance_gametick() -> void:
	var current_access : GameAccess = get_current_game_access()
	print()
	print(current_access)
	
	current_access.card_processor.process_events()
	
	_current_gametick += 1
	_game_access_by_gametick[_current_gametick] = current_access.duplicate()
	var new_access : GameAccess = get_current_game_access()
	new_access.card_processor.event_history.set_current_gametick(_current_gametick)
	print(new_access)
	
	advanced_to_new_gametick.emit(_current_gametick)

func revert_to_gametick(gametick : int) -> void:
	for i in range(_current_gametick, gametick, -1):
		_game_access_by_gametick.erase(i)
	_current_gametick = gametick
