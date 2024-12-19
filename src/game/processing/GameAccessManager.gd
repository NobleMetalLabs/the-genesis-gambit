class_name GameAccessManager
extends RefCounted


var event_history := EventHistory.new()
var event_scheduler := EventScheduler.new(event_history)
var card_processor := CardProcessor.new(event_scheduler)
var game_access := GameAccess.new(card_processor)

var _game_access_delta_by_gametick : Dictionary = {}
var _current_gametick : int = 0

signal advanced_to_new_gametick(gametick : int)

func advance_gametick() -> void:
	#var delta_recorder : GameAccessDeltaRecorder = GameAccessDeltaRecorder.new()
	game_access.card_processor.process_events()
	#_game_access_delta_by_gametick[_current_gametick] = delta_recorder.get_delta()
	
	_current_gametick += 1
	#_game_access_by_gametick[_current_gametick] = current_access.duplicate()
	#var new_access : GameAccess = get_current_game_access()
	#new_access.card_processor.event_history.set_current_gametick(_current_gametick)
	#print(new_access)
	
	advanced_to_new_gametick.emit(_current_gametick)

#func revert_to_gametick(gametick : int) -> void:
	#for i in range(_current_gametick, gametick, -1):
		#_game_access_by_gametick.erase(i)
	#_current_gametick = gametick

func apply_game_access_delta(delta : GameAccessDelta) -> void:
	game_access.event_scheduler._register_bulk(delta.new_processing_steps)
	game_access.event_scheduler._unregister_bulk(delta.removed_processing_steps)
	
	for changed_property : Dictionary in delta.changed_local_properties:
		changed_property["object"].set(changed_property["property"], changed_property["new_value"])
	
	for changed_stat : Dictionary in delta.changed_statistics:
		changed_stat["possessor"].set_statistic(changed_stat["statistic"], changed_stat["new_value"])

func revert_game_access_delta(delta : GameAccessDelta) -> void:
	game_access.event_scheduler._unregister_bulk(delta.new_processing_steps)
	game_access.event_scheduler._register_bulk(delta.removed_processing_steps)
	
	for changed_property : Dictionary in delta.changed_local_properties:
		changed_property["object"].set(changed_property["property"], changed_property["old_value"])
	
	for changed_stat : Dictionary in delta.changed_statistics:
		changed_stat["possessor"].set_statistic(changed_stat["statistic"], changed_stat["old_value"])
