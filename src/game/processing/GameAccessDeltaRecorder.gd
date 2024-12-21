class_name GameAccessDeltaRecorder
extends RefCounted

var _delta := GameAccessDelta.new()

func get_delta() -> GameAccessDelta:
	return _delta

var _saved_object_values_by_object : Dictionary
func save_objects(objects : Array[Object]) -> void:
	for object in objects:
		var property_list : Array[Dictionary] = object.get_property_list()
		var script_variables : Array[Dictionary] = property_list.filter(func get_script_variables(p : Dictionary) -> bool: return p["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE)
		var variable_names : Array[String] = []
		variable_names.assign(script_variables.map(func(p : Dictionary) -> String: return p.name))

		var requester_properties : Dictionary
		for var_name in variable_names: 
			var var_value : Variant = object.get(var_name)
			if var_value is Array or var_value is Dictionary: var_value = var_value.duplicate()
			requester_properties[var_name] = var_value

		_saved_object_values_by_object[object] = requester_properties

func record_object_deltas(objects : Array[Object]) -> void:
	for object in objects:
		var property_dict : Dictionary = _saved_object_values_by_object[object]
		for property : StringName in property_dict:
			if property_dict[property] == object.get(property):
				continue
			var record_dict : Dictionary = {
				"object": object,
				"property": property,
				"old_value": property_dict[property],
				"new_value": object.get(property)
			}
			_delta.changed_local_properties.append(record_dict)

var _saved_stat_values_by_possessor : Dictionary
func save_statistics(objects : Array[Object]) -> void:
	var possessors : Array[IStatisticPossessor] = []
	possessors.assign(objects.map(
		func get_statistic_possessor(obj : Object) -> IStatisticPossessor:
			if obj is not Node: return null
			return IStatisticPossessor.id(obj)
	))
	for possessor in possessors:
		if possessor == null: continue
		_saved_stat_values_by_possessor[possessor] = possessor._statistic_db.duplicate(true)

func record_stat_deltas(objects : Array[Object]) -> void:
	var possessors : Array[IStatisticPossessor] = []
	possessors.assign(objects.map(
		func get_statistic_possessor(obj : Object) -> IStatisticPossessor:
			if obj is not Node: return null
			return IStatisticPossessor.id(obj)
	))
	for possessor in possessors:
		if possessor == null: continue
		var saved_dict : Dictionary = _saved_stat_values_by_possessor[possessor]
		var stat_dict : Dictionary = possessor._statistic_db
		for stat : Genesis.Statistic in stat_dict:
			if saved_dict.has(stat): 
				if stat_dict[stat] == possessor.get_statistic(stat):
					continue
			var record_dict : Dictionary = {
				"possessor": possessor,
				"statistic": stat,
				"old_value": saved_dict.get(stat, Genesis.STATISTIC_DEFAULTS[stat]),
				"new_value": possessor.get_statistic(stat)
			}
			_delta.changed_statistics.append(record_dict)
