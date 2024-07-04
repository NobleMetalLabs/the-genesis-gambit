#class_name MultiplayerManager
extends Node

signal network_update()

var multiplayer_peer := ENetMultiplayerPeer.new()
var player_name : String = ""

var network_player : NetworkPlayer
var peer_id_to_player : Dictionary = {} #[int, NetworkPlayer]

var ADDRESS : String
const PORT = 31570

var upnp : UPNP = UPNP.new()
func _ready() -> void:
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)

	var discover_result := upnp.discover() as UPNP.UPNPResult
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			var result_udp := upnp.add_port_mapping(PORT, PORT, "Genesis Gambit Multiplayer", "UDP")
			var result_tcp := upnp.add_port_mapping(PORT, PORT, "Genesis Gambit Multiplayer", "TCP")
			if not result_udp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(PORT, PORT, "", "UDP")
			if not result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(PORT, PORT, "", "TCP")
		ADDRESS = upnp.query_external_address()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		upnp.delete_port_mapping(PORT, "UDP")
		upnp.delete_port_mapping(PORT, "TCP")

func is_instance_server() -> bool:
	if multiplayer == null: return false
	return multiplayer.get_unique_id() == 1

func host_lobby() -> void:
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Server started on port %s with clientid %s" % [PORT, multiplayer.get_unique_id()])
	network_player = NetworkPlayer.new(multiplayer.get_unique_id(), player_name)
	assign_player_networkplayer(multiplayer.get_unique_id(), network_player.to_dict())
	network_update.emit()

func join_lobby(address : String = "127.0.0.1") -> void:
	print(address)
	multiplayer_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Joined server with clientid %s" % [multiplayer.get_unique_id()])
	network_player = NetworkPlayer.new(multiplayer.get_unique_id(), player_name)
	assign_player_networkplayer(multiplayer.get_unique_id(), network_player.to_dict())

func exit_lobby() -> void:
	multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	peer_id_to_player.clear()
	print("Left server")
	network_update.emit()

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
	network_update.emit()

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
	network_update.emit()