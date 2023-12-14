class_name GamefieldManager
extends Node

@onready var card_scn : PackedScene = preload("res://scn/objects/CardInstance.tscn")

func export_gamefield_state() -> GamefieldState:
	return null

func load_gamefield_state(_state: GamefieldState) -> void:
	pass

func place_card(_player : Player, _data : CardMetadata, position : Vector2) -> void:
	var new_card : CardInstance = card_scn.instantiate()
	new_card.data = _data
	new_card.position = position
	get_parent().get_node("Cards").add_child(new_card, true)
