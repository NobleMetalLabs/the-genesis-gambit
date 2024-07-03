class_name MultiplayerAuthoritySource
extends AuthoritySource

var multiplayer_peer := ENetMultiplayerPeer.new()

const ADDRESS = "127.0.0.1"
const PORT = 9999

func _ready() -> void:
	$host.pressed.connect(
		func() -> void:
			$host.visible = false
			$join.visible = false
			host_game()
	)
	$join.pressed.connect(
		func() -> void:
			$host.visible = false
			$join.visible = false
			join_game()
	)
	$LineEdit.text_submitted.connect(
		message_submitted
	)

func host_game() -> void:
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Server started on port %s with clientid %s" % [PORT, multiplayer.get_unique_id()])

func join_game() -> void:
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Joined server with clientid %s" % [multiplayer.get_unique_id()])

func message_submitted(message: String) -> void:
	rpc("update_chatbox", message)

@rpc("call_local", "any_peer")
func update_chatbox(message: String) -> void:
	$Label.text = message