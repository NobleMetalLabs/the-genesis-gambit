class_name ITargetable
extends Identifier

static func id(node : Node) -> ITargetable:
	if node is Identifier:
		node = node.get_object()
	if node == null: return null
	if not node.has_node("ITargetable"): return null
	return node.get_node("ITargetable")

func _init() -> void:
	self.name = "ITargetable"

func clone() -> ITargetable:
	return ITargetable.new().copy(self)

func _to_string() -> String:
	var maybe_ci := ICardInstance.id(self)
	return "ITargetable(%s)" % [str(self) if not maybe_ci else str(maybe_ci)]

func get_boundary_rectangle() -> Rect2:
	if self.get_object().has_method("get_boundary_rectangle"):
		return self.get_object().get_boundary_rectangle()
	assert(false, "Class [%s] identifies as an ITargetable but does not implement 'get_boundary_rectangle()'" % [self.get_object()])
	return Rect2()