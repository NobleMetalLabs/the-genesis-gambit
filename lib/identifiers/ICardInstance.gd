class_name ICardInstance
extends Identifier
static func id(node : Node) -> ICardInstance:
	if node == null: return null
	if node is Identifier:
		node = node.get_object()
	if not node.has_node("ICardInstance"): return null
	return node.get_node("ICardInstance")
	
var metadata : CardMetadata

func _init(_metadata : CardMetadata = null) -> void:
	self.name = "ICardInstance"
	metadata = _metadata

func get_metadata() -> CardMetadata:
	return metadata
