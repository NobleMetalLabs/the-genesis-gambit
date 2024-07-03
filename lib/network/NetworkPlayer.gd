class_name NetworkPlayer
extends Resource

var peer_id : int
var player_name : StringName
var pack_stack : PackStack 

func _init(_peer_id : int, _player_name : StringName) -> void:
	self.peer_id = _peer_id
	self.player_name = _player_name
	self.pack_stack = PackStack.new()

func to_dict() -> Dictionary:
	return {
		"peer_id" : peer_id,
		"player_name" : player_name
	}

func _to_string() -> String:
	return "NetworkPlayer(%s, %s)" % [peer_id, player_name]

static func from_dict(dict : Dictionary) -> NetworkPlayer:
	return NetworkPlayer.new(dict["peer_id"], dict["player_name"])