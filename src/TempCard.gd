class_name TempCard
extends Node2D

var metadata : CardMetadata
@onready var sprite : Sprite2D = $Sprite2D

var gamefield_manager : GamefieldManager

func _ready():
	sprite.texture = metadata.image
	gamefield_manager = get_parent().get_parent().get_node("Gamefield").get_node("GamefieldManager")

func _input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		gamefield_manager.place_card(null, metadata, global_position)
		queue_free()

func _process(_delta : float) -> void:
	position = get_global_mouse_position()
