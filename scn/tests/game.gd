class_name Game
extends Node

signal game_completed()

func _ready() -> void:
	var dummy_match := NetworkMatch.new(NetworkMatchConfiguration.dummy_config)
	dummy_match.dispatch_play_stage.connect(dispatch_play_stage)
	dummy_match.start_match()

var gamefield_scene : PackedScene = preload("res://scn/game/Gamefield.tscn")
var client_ui_scene : PackedScene = preload("res://scn/ui/ClientUI.tscn")

func dispatch_play_stage(config : NetworkPlayStageConfiguration) -> void:
	var gamefield : Gamefield = gamefield_scene.instantiate()
	gamefield.setup(config)
	gamefield.game_completed.connect(game_completed.emit)
	var client_ui : ClientUI = client_ui_scene.instantiate()
	gamefield.client_ui = client_ui
	client_ui.gamefield = gamefield
	Router.gamefield = gamefield
	Router.client_ui = client_ui
	self.add_child(gamefield)
	self.add_child(client_ui)