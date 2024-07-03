#class_name Utils
extends Node

func get_vector_to_rectangle_edge_at_angle(rect : Rect2, angle : float) -> Vector2:
	# TODO: Make this shit better
	var half_bounds : Vector2 = rect.size / 2
	var tri_angle : float = abs(Vector2.from_angle(angle)).angle()
	var bleed : float = 0.2
	var to_edge : Vector2
	if half_bounds.angle() < tri_angle:
	 	#Vertical Edge
		to_edge = Vector2.from_angle(angle) * Vector2(half_bounds.y, tan((PI / 2) - tri_angle) * half_bounds.y).length()
	else:
		#Horizontal Edge
		to_edge = Vector2.from_angle(angle) * Vector2(half_bounds.x, tan(tri_angle) * half_bounds.x).length()
	return to_edge * (1 - bleed)

func object_to_dict(obj : Object, deep : bool = false, include_paths : bool = false) -> Dictionary:
	var obj_dict : Dictionary = inst_to_dict(obj)
	for key : String in obj_dict.keys().duplicate():
		var value : Variant = obj_dict[key]
		if deep and value is Object:
			obj_dict[key] = object_to_dict(value, deep, include_paths)
		if value is Array:
			obj_dict[key] = _array_to_deep_array(value, deep, include_paths)
		if not include_paths:
			if key.begins_with("@"):
				obj_dict.erase(key)
	return obj_dict

func _array_to_deep_array(array : Array, deep : bool = false, include_paths : bool = false) -> Array:
	var new_arr : Array = []
	for value : Variant in array:
		if deep and value is Object:
			new_arr.append(object_to_dict(value, deep, include_paths))
		elif value is Array:
			new_arr.append(_array_to_deep_array(value, deep, include_paths))
		else:
			new_arr.append(value)
	return new_arr
