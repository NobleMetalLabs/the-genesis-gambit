class_name IGrabbable
extends Identifier

static func id(node : Node) -> IGrabbable:
	if node is Identifier:
		node = node.get_object()
	if node == null: return null
	if not node.has_node("IGrabbable"): return null
	return node.get_node("IGrabbable")

func _init() -> void:
	self.name = "IGrabbable"

func clone() -> IGrabbable:
	return IGrabbable.new().copy(self)

func _to_string() -> String:
	var maybe_ci := ICardInstance.id(self)
	return "IGrabbable(%s)" % [str(self) if not maybe_ci else str(maybe_ci)]