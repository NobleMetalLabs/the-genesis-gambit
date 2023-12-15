class_name TempCard
extends Node2D

var metadata : CardMetadata
var gamefield_manager : GamefieldManager
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	gamefield_manager = get_parent().get_node("%GAMEFIELD").manager
	sprite.texture = metadata.image

func _input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		gamefield_manager.place_card(gamefield_manager.get_own_player(), metadata, global_position)
		self.queue_free()

func _process(_delta : float) -> void:
	position = get_global_mouse_position()
