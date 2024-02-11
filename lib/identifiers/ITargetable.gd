class_name ITargetable
extends Identifier
static func id(node : Node) -> ITargetable:
	return node.get_node("ITargetable")