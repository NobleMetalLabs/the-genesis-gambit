#class_name MultiplayerManager
extends Node

signal players_update()

var multiplayer_peer := ENetMultiplayerPeer.new()
var player_name : String = ""

var network_player : NetworkPlayer
var peer_id_to_player : Dictionary = {} #[int, NetworkPlayer]

const ADDRESS = "127.0.0.1"
const PORT = 9999

func _ready() -> void:
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)

func host_lobby() -> void:
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Server started on port %s with clientid %s" % [PORT, multiplayer.get_unique_id()])
	network_player = NetworkPlayer.new(multiplayer.get_unique_id(), player_name)
	assign_player_networkplayer(multiplayer.get_unique_id(), network_player.to_dict())
	players_update.emit()

func join_lobby() -> void:
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Joined server with clientid %s" % [multiplayer.get_unique_id()])
	network_player = NetworkPlayer.new(multiplayer.get_unique_id(), player_name)
	assign_player_networkplayer(multiplayer.get_unique_id(), network_player.to_dict())

func exit_lobby() -> void:
	multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	peer_id_to_player.clear()
	print("Left server")
	players_update.emit()

func on_player_connected(peer_id : int) -> void:
	print("%s : Player <%s> connected." % [multiplayer.get_unique_id(), peer_id])
	var mid : int = multiplayer.get_unique_id()
	rpc_id(peer_id, "request_player_meta", mid)

func on_player_disconnected(peer_id : int) -> void:
	print("%s : Player <%s> disconnected." % [multiplayer.get_unique_id(), peer_id])
	if peer_id == 1:
		exit_lobby.call_deferred()
		print("Host disconnected.")
		return
	peer_id_to_player.erase(peer_id)
	players_update.emit()

@rpc("any_peer")
func request_player_meta(requester_id : int) -> void:
	print("%s : Requested player meta from <%s>" % [multiplayer.get_unique_id(), requester_id])
	var mid : int = multiplayer.get_unique_id()
	rpc_id(requester_id, "assign_player_networkplayer", mid, NetworkPlayer.new(mid, player_name).to_dict())

@rpc("any_peer")
func assign_player_networkplayer(peer_id : int, _network_player : Variant) -> void:
	print("%s : Assigning network_player for <%s>" % [multiplayer.get_unique_id(), peer_id])
	var player : NetworkPlayer
	if _network_player is Dictionary:
		player = NetworkPlayer.from_dict(_network_player)
	else:
		player = _network_player
	print(player)
	peer_id_to_player[peer_id] = player
	players_update.emit()