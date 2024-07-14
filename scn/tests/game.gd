class_name Game
extends Node

signal game_completed()

func _ready() -> void:
	var dummy_match := NetworkMatch.new(NetworkMatchConfiguration.dummy_config)
	dummy_match.dispatch_play_stage.connect(dispatch_play_stage)
	dummy_match.start_match()

var backend_scene : PackedScene = preload("res://scn/game/MatchBackend.tscn")
var client_ui_scene : PackedScene = preload("res://scn/ui/sections/ClientUI.tscn")

func dispatch_play_stage(config : NetworkPlayStageConfiguration) -> void:
	var backend : MatchBackend = backend_scene.instantiate()
	backend.setup(config)
	backend.game_completed.connect(game_completed.emit)
	var client_ui : ClientUI = client_ui_scene.instantiate()
	backend.client_ui = client_ui
	client_ui.backend = backend
	Router.backend = backend
	Router.client_ui = client_ui
	self.add_child(backend)
	self.add_child(client_ui)