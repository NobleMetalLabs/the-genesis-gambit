class_name IMoodPossessor
extends Identifier

static func id(node : Node) -> IMoodPossessor:
	if node == null: return null
	if node is Identifier:
		node = node.get_object()
	return node.get_node("IMoodPossessor")

var _active_moods : Array[Dictionary] = []

func apply_mood(data : Dictionary) -> void:
	_active_moods.append(data)

func remove_mood(data : Dictionary) -> void:
	_active_moods.erase(data)

func _get_statistic(statistic_name : String, base_value : Variant) -> Variant:
	# for mood in _active_moods:
	# 	if mood.has(statistic_name):
	# 		value += mood[statistic_name]
	return base_value