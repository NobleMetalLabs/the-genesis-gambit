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

func _init(_metadata : CardMetadata, _player : Player, _game_access : GameAccess) -> void:
	self.name = "ICardInstance"
	metadata = _metadata
	logic = metadata.logic_script.new(self, _game_access)
	logic.owner = self
	player = _player

func clone() -> ICardInstance:
	return ICardInstance.new(self.metadata, self.player, self.logic.game_access)

func get_metadata() -> CardMetadata:
	return metadata

func _to_string() -> String:
	var player_name : String = "null"
	if player != null:
		player_name = player.name
	if UIDDB.has_object(self.get_object()):
		return "Card[%s<%s, %s>]" % [UIDDB.uid(self.get_object()), metadata.name, player_name]
	return "Card[%s, %s]" % [metadata.name, player_name]
