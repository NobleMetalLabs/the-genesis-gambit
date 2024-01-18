class_name TempCard
extends Node2D

var metadata : CardMetadata
var ui : ClientUI

signal was_placed()
signal was_canceled()

@onready var sprite : Sprite2D = $Sprite2D

func _setup(_ui : ClientUI, _metadata : CardMetadata) -> void:
	ui = _ui
	metadata = _metadata

func _ready() -> void:
	sprite.texture = metadata.image

func _input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		if visible: ui.gamefield.place_card(ui.gamefield.get_own_player(), metadata, global_position)
		self.was_placed.emit()
		self.queue_free()
	if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		self.was_canceled.emit()
		self.queue_free()

func _process(_delta : float) -> void:
	position = get_global_mouse_position()
	visible = (position.y <= 465) #TODO: boy what the hell boy
