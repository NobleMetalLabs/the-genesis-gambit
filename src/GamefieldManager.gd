class_name GamefieldManager
extends Node

@onready var gamefield : Gamefield = get_parent()
@onready var card_scn : PackedScene = preload("res://scn/objects/CardInstance.tscn")

func export_gamefield_state() -> GamefieldState:
	return null

func load_gamefield_state(_state: GamefieldState) -> void:
	pass

func place_card(player : Player, metadata : CardMetadata, position : Vector2) -> void:
	var new_card : CardInstance = card_scn.instantiate()
	new_card.metadata = metadata
	new_card.position = position
	new_card.player_owner = player
	new_card.gamefield = gamefield
	gamefield.event.connect(func(event_name : StringName, data : Dictionary) -> void:
		new_card.logic.process_event(event_name, data)
	)
	gamefield.cards_parent.add_child(new_card, true)
