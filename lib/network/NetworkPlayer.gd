class_name NetworkPlayer
extends Serializeable

var peer_id : int
var player_name : StringName

static func setup(_peer_id : int, _player_name : StringName) -> NetworkPlayer:
	var np := NetworkPlayer.new()
	np.peer_id = _peer_id
	np.player_name = _player_name
	return np

func _to_string() -> String:
	return "NetworkPlayer(%s, \"%s\")" % [peer_id, player_name]