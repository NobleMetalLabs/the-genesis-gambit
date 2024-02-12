class_name ITargetable
extends Identifier
static func id(node : Node) -> ITargetable:
	if node is Identifier:
		node = node.get_object()
	return node.get_node("ITargetable")
