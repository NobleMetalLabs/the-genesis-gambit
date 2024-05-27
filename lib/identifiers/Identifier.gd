class_name Identifier
extends Node

func copy(existing : Identifier) -> void:
	var property_list : Array[Dictionary] = existing.get_property_list()
	property_list.reverse()
	for property in property_list:
		var property_name : StringName = property["name"]
		if property_name.ends_with(".gd"): continue
		if property_name.is_empty(): continue
		if property_name == "Script": break
		self.set(property_name, existing.get(property_name))

func get_object() -> Node:
	return self.get_parent()