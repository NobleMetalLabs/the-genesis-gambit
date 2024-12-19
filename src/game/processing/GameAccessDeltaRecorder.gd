class_name GameAccessDeltaRecorder
extends RefCounted

var _delta := GameAccessDelta.new()

func get_delta() -> GameAccessDelta:
	return _delta

func save_object(object : Object) -> void:
	save_objects([object])

func save_objects(objects : Array[Object]) -> void:
	for object in objects:
		_save_object_property_values(object)

func record_object_delta(object : Object) -> void:
	record_object_deltas([object])

func record_object_deltas(objects : Array[Object]) -> void:
	for object in objects:
		_record_changed_object_property_values(object)

var _saved_object_values_by_object : Dictionary
func _save_object_property_values(object : Object) -> void:
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

var _changed_object_properties : Array[Dictionary] = []
func _record_changed_object_property_values(object : Object) -> void:
	var property_dict : Dictionary = _saved_object_values_by_object[object]
	for property : StringName in property_dict:
		if property_dict[property] != object.get(property):
			var record_dict : Dictionary = {
				"object": object,
				"property": property,
				"old_value": property_dict[property],
				"new_value": object.get(property)
			}
			print(record_dict)
			_changed_object_properties.append(record_dict)