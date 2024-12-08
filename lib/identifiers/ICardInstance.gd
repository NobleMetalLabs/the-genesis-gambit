class_name ICardInstance
extends Identifier
static func id(node : Node) -> ICardInstance:
	if node is Identifier:
		node = node.get_object()
	if node == null: return null
	if not node.has_node("ICardInstance"): return null
	return node.get_node("ICardInstance")

var metadata : CardMetadata
var logic : CardLogic
var player : Player

func _init(_metadata : CardMetadata, _player : Player) -> void:
	self.name = "ICardInstance"
	metadata = _metadata
	logic = metadata.logic_script.new(self)
	logic.owner = self
	player = _player

func clone() -> ICardInstance:
	return ICardInstance.new(self.metadata, self.player)

func get_metadata() -> CardMetadata:
	return metadata

func _to_string() -> String:
	var player_name : String = "null"
	if player != null:
		player_name = player.name
	return "ICardInstance(%s, %s)" % [metadata.name, player_name]
