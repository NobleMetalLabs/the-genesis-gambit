class_name ICardInstance
extends Identifier
static func id(node : Node) -> ICardInstance:
	if node == null: return null
	if node is Identifier:
		node = node.get_object()
	if not node.has_node("ICardInstance"): return null
	return node.get_node("ICardInstance")
	
static func dupe(node : Node) -> ICardInstance:
	if not node is ICardInstance:
		node = ICardInstance.id(node)
	return ICardInstance.new(node.metadata)

var metadata : CardMetadata
var logic : CardLogic

func _init(_metadata : CardMetadata) -> void:
	self.name = "ICardInstance"
	metadata = _metadata
	logic = metadata.logic_script.new(self)

func get_metadata() -> CardMetadata:
	return metadata
