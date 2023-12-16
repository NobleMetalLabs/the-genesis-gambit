class_name Gamefield
extends Node

signal event(name : StringName, data : Dictionary)

@export var card_instance_scene : PackedScene
@onready var cards_holder : Node2D = get_node("Cards")

func export_gamefield_state() -> GamefieldState:
	return null

func load_gamefield_state(_state: GamefieldState) -> void:
	pass

func get_own_player() -> Player:
	#for player in gamefield.players:
	#	if player.something == this_client:
	#	return player
	return null

var _hovered_card : CardInstance = null
func get_hovered_card() -> CardInstance:
	return _hovered_card

func place_card(player : Player, metadata : CardMetadata, position : Vector2) -> void:
	var new_card : CardInstance = card_instance_scene.instantiate()
	new_card.metadata = metadata
	new_card.position = position
	new_card.player_owner = player
	new_card.gamefield = self
	self.event.connect(func(event_name : StringName, data : Dictionary) -> void:
		new_card.logic.process_event(event_name, data)
	)
	new_card.get_node("Area2D").mouse_entered.connect(
		func() -> void:
			_hovered_card = new_card
	)
	new_card.get_node("Area2D").mouse_exited.connect(
		func() -> void:
			_hovered_card = null
	)
	cards_holder.add_child(new_card, true)
	var ap : AudioStreamPlayer2D = AudioDispatcher.dispatch_positional_audio(new_card, "res://ast/sound/cardplace.tres")
	ap.panning_strength = 0.25


