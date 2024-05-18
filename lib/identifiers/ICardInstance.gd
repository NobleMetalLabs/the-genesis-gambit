class_name ICardInstance
extends Identifier
static func id(node : Node) -> ICardInstance:
	if node == null: return null
	if node is Identifier:
		node = node.get_object()
	return node.get_node("ICardInstance")
	
var metadata : CardMetadata

func _init(_metadata : CardMetadata = null) -> void:
	metadata = _metadata

func get_metadata() -> CardMetadata:
	return metadata
