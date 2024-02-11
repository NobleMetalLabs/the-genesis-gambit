class_name ICardInstance
extends Identifier
static func id(node : Node) -> ICardInstance:
	return node.get_node("ICardInstance")

var metadata : CardMetadata

func get_metadata() -> CardMetadata:
	return metadata