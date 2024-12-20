class_name GameAccessManager
extends RefCounted

var event_history := EventHistory.new()
var event_processing_step_manager := EventProcessingStepManager.new()
var event_processor := EventProcessor.new(event_processing_step_manager, event_history)
var game_access := GameAccess.new(event_processor)

var _game_access_delta_by_gametick : Dictionary = {}
var _current_gametick : int = 0

const MAX_NUM_SAVED_HISTORIES := 300

signal advanced_to_new_gametick(gametick : int)

func advance_gametick() -> void:
	var delta_recorder : GameAccessDeltaRecorder = GameAccessDeltaRecorder.new()
	game_access.event_processor.process_events(delta_recorder)
	var delta : GameAccessDelta = delta_recorder.get_delta()
	if not delta.is_empty(): _game_access_delta_by_gametick[_current_gametick] = delta
	_current_gametick += 1
	event_history.set_current_gametick(_current_gametick)
	advanced_to_new_gametick.emit(_current_gametick)

func revert_to_gametick(gametick : int) -> void:
	print("Reverting to gametick %s" % gametick)
	for i in range(_current_gametick - 1, gametick - 1, -1):
		if _game_access_delta_by_gametick.has(i):
			revert_game_access_delta(_game_access_delta_by_gametick[i])
			_game_access_delta_by_gametick.erase(i)
	event_history._events_by_gametick.erase(_current_gametick)
	_current_gametick = gametick
	event_history.set_current_gametick(_current_gametick)
	advanced_to_new_gametick.emit(_current_gametick)

func apply_game_access_delta(delta : GameAccessDelta) -> void:
	game_access.event_processing_step_manager._register_bulk(delta.new_processing_steps)
	game_access.event_processing_step_manager._unregister_bulk(delta.removed_processing_steps)
	
	for changed_property : Dictionary in delta.changed_local_properties:
		changed_property["object"].set(changed_property["property"], changed_property["new_value"])
	
	for changed_stat : Dictionary in delta.changed_statistics:
		changed_stat["possessor"].set_statistic(changed_stat["statistic"], changed_stat["new_value"])

func revert_game_access_delta(delta : GameAccessDelta) -> void:
	game_access.event_processing_step_manager._unregister_bulk(delta.new_processing_steps)
	game_access.event_processing_step_manager._register_bulk(delta.removed_processing_steps)
	
	for changed_property : Dictionary in delta.changed_local_properties:
		print("Reverting property change: %s" % changed_property)
		changed_property["object"].set(changed_property["property"], changed_property["old_value"])
	
	for changed_stat : Dictionary in delta.changed_statistics:
		print("Reverting statistic change: %s" % changed_stat)
		changed_stat["possessor"].set_statistic(changed_stat["statistic"], changed_stat["old_value"])
