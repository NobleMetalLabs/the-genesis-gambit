class_name Game
extends Node

signal new_match_started(nmatch : NetworkMatch)
signal match_completed()

var backend_scene : PackedScene = preload("res://scn/game/MatchBackend.tscn")
var client_ui_scene : PackedScene = preload("res://scn/ui/sections/ClientUI.tscn")

@onready var lobby_ui : MultiplayerLobbyUI = $"MultiplayerLobbyUI"

func _ready() -> void:
	self.get_tree().get_root().content_scale_size = Vector2.ZERO

	lobby_ui.match_start_requested.connect(func () -> void:
		MultiplayerManager.send_network_message("nmatch/start", [])
	)

	MultiplayerManager.received_network_message.connect(handle_network_message)

	new_match_started.connect(handle_new_match_started)
	match_completed.connect(handle_match_completed)

func handle_network_message(_sender : NetworkPlayer, message : String, args : Array) -> void:
	match(message):
		"nmatch/start":
			var players : Array[NetworkPlayer] = []
			players.assign(MultiplayerManager.peer_id_to_player.values())
			var nmatch := NetworkMatch.new(
				NetworkMatchConfiguration.new(players, MatchRuleset.new())
			)
			new_match_started.emit(nmatch)
		"nmatch/end":
			match_completed.emit(args[0])

func handle_new_match_started(nmatch : NetworkMatch) -> void:
	lobby_ui.hide()
	nmatch.dispatch_play_stage.connect(_dispatch_play_stage)
	nmatch.start_match()

func handle_match_completed() -> void:
	Router.backend.process_mode = Node.PROCESS_MODE_DISABLED
	var win_timer : Timer = Timer.new()
	win_timer.wait_time = 5
	win_timer.one_shot = true
	win_timer.autostart = true
	win_timer.timeout.connect(
		func reset_game() -> void:
			Router.client_ui.queue_free()
			Router.client_ui = null
			Router.backend.queue_free()
			Router.backend = null
			UIDDB.clear()
			win_timer.queue_free()
			lobby_ui.show()
	)
	self.add_child(win_timer)

func _dispatch_play_stage(config : NetworkPlayStageConfiguration) -> void:
	var backend : MatchBackend = backend_scene.instantiate()
	var client_ui : ClientUI = client_ui_scene.instantiate()
	Router.backend = backend
	Router.client_ui = client_ui
	self.add_child(backend)
	self.add_child(client_ui)
	backend.setup(config)
	client_ui.setup(config)
	backend.game_completed.connect(match_completed.emit)