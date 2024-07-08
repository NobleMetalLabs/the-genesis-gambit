class_name MultiplayerLobbyUI
extends Control

func _ready() -> void:
	$"%GAME-BUTTONS-STACK/HOST".disabled = true
	$"%GAME-BUTTONS-STACK/JOIN".disabled = true
	$"%GAME-BUTTONS-STACK/HOST".pressed.connect(request_host_lobby)
	$"%GAME-BUTTONS-STACK/JOIN".pressed.connect(request_join_lobby)
	$"%GAME-BUTTONS-STACK/START".pressed.connect(request_start_game)
	$"%GAME-BUTTONS-STACK/EXIT".pressed.connect(request_exit_lobby)

	var player_name_lineedit : LineEdit = $"%PLAYER-NAME-LINEEDIT"
	player_name_lineedit.text_submitted.connect(
		func submit_text(text : String) -> void: 
			player_name_lineedit.clear()
			request_name_submission(text)
	)
	var chat_lineedit : LineEdit = $"%CHAT-LINEEDIT"
	chat_lineedit.text_submitted.connect(
		func submit_text(text : String) -> void: 
			chat_lineedit.clear()
			request_chat_message(text)
	)

	MultiplayerManager.network_update.connect(
		func update() -> void:
			update_player_list()
			update_address_field()
	)

func request_host_lobby() -> void:
	MultiplayerManager.host_lobby(true)
	_update_game_buttons(true, true)
	reset_chatbox()

func request_join_lobby() -> void:
	var address : String = address_lineedit.text
	if not address.is_valid_ip_address(): 
		address_lineedit.text = "Invalid address."
		return
	MultiplayerManager.join_lobby(address)
	_update_game_buttons(true, false)
	reset_chatbox()

func request_start_game() -> void:
	pass

func _start_game(network_match : NetworkMatch) -> void:
	print("Starting game with match configuration: %s" % network_match)
	pass

func request_exit_lobby() -> void:
	MultiplayerManager.exit_lobby()
	_update_game_buttons(false, false)
	reset_chatbox()
	address_lineedit.text = ""

func _update_game_buttons(is_in_lobby : bool, is_host : bool) -> void:
	$"%GAME-BUTTONS-STACK/HOST".visible = not is_in_lobby
	$"%GAME-BUTTONS-STACK/JOIN".visible = not is_in_lobby
	$"%GAME-BUTTONS-STACK/START".visible = is_in_lobby and is_host
	$"%GAME-BUTTONS-STACK/EXIT".visible = is_in_lobby

func request_name_submission(player_name : String) -> void:
	$"%GAME-BUTTONS-STACK/HOST".disabled = false
	$"%GAME-BUTTONS-STACK/JOIN".disabled = false
	$"%PLAYER-NAME-LINEEDIT".clear()
	MultiplayerManager.player_name = player_name

func request_chat_message(message : String) -> void:
	var packet : Dictionary = {"peer_id" : multiplayer.get_unique_id(), "message" : message}
	rpc("update_chatbox", packet)
	
@onready var chat_message_list : VBoxContainer = $"%CHAT-MESSAGE-LIST"
@onready var chat_message_template : Label = $"%CHAT-MESSAGE-TEMPLATE"

func reset_chatbox() -> void:
	for child in chat_message_list.get_children():
		if child == chat_message_template: continue
		child.queue_free()

@rpc("call_local", "any_peer")
func update_chatbox(dict : Dictionary) -> void:
	var chat_message : Label = chat_message_template.duplicate()
	var id : int = dict["peer_id"]
	var pname : String = MultiplayerManager.peer_id_to_player[id].player_name
	chat_message.text = "%s : %s" % [pname, dict["message"]]
	chat_message.visible = true
	chat_message_list.add_child(chat_message)

@onready var player_list : VBoxContainer = $"%PLAYER-LIST"
@onready var player_template : Label = $"%PLAYER-TEMPLATE"

func update_player_list() -> void:
	for child in player_list.get_children():
		if child == player_template: continue
		child.queue_free()
	var players : Array = MultiplayerManager.peer_id_to_player.values()
	players.sort_custom(func(a : NetworkPlayer, b : NetworkPlayer) -> bool: return a.peer_id < b.peer_id)
	for player : NetworkPlayer in players:
		var player_label : Label = player_template.duplicate()
		player_label.text = player.player_name
		player_label.visible = true
		player_list.add_child(player_label)

@onready var address_lineedit : LineEdit = $"%ADDRESS-LINEEDIT"

func update_address_field() -> void:
	if MultiplayerManager.is_instance_server():
		address_lineedit.text = "Players join with address: %s" % MultiplayerManager.ADDRESS
	else:
		address_lineedit.text = "Connected to server at address: %s" % MultiplayerManager.ADDRESS