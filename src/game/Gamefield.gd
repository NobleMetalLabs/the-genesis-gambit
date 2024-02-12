class_name Gamefield
extends Node

signal event(name : StringName, data : Dictionary)

@onready var cards_holder : Node2D = get_node("Cards")
@onready var client_ui : ClientUI = get_parent().get_node("CLIENT-UI")

func export_gamefield_state() -> GamefieldState:
	return null

func load_gamefield_state(_state: GamefieldState) -> void:
	pass

func get_own_player() -> Player:
	#for player in gamefield.players:
	#	if player.something == this_client:
	#	return player
	return null

var _hovered_card : CardOnField = null
func get_hovered_card() -> CardOnField:
	return _hovered_card

# make panning strength a user setting
func place_card(player : Player, metadata : CardMetadata, position : Vector2) -> void:
	var new_card : CardOnField = ObjectDB._CardOnField.create(self, metadata, player)
	new_card.position = position

	self.event.connect(func(event_name : StringName, data : Dictionary) -> void:
		new_card.logic.process_event(event_name, data)
	)
	new_card.mouse_entered.connect(
		func() -> void:
			_hovered_card = new_card
	)
	new_card.mouse_exited.connect(
		func() -> void:
			_hovered_card = null
	)
	
	cards_holder.add_child(new_card, true)
	var ap : AudioStreamPlayer2D = AudioDispatcher.dispatch_positional_audio(new_card, "res://ast/sound/cardplace.tres")
	ap.panning_strength = 0.25


