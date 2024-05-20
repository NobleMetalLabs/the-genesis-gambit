class_name IMoodPossessor
extends Identifier

static func id(node : Node) -> IMoodPossessor:
	if node == null: return null
	if node is Identifier:
		node = node.get_object()
	return node.get_node("IMoodPossessor")

var active_moods : Array[Dictionary] = []

func apply_mood(data : Dictionary) -> void:
	active_moods.append(data)

func remove_mood(data : Dictionary) -> void:
	active_moods.erase(data)