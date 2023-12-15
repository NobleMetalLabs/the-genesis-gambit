class_name CardInstance
extends Node

var gamefield : Gamefield
var metadata : CardMetadata
var logic : CardLogic
var player_owner : Player

@onready var area : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite2D
var dragging : bool = false
var dragging_offset : Vector2 = Vector2.ZERO

func _ready() -> void:
	area.input_event.connect(
		func (_viewport : Viewport, event : InputEvent, _shape_idx : int) -> void:
			if not event is InputEventMouseButton: return
			if not event.button_index == MOUSE_BUTTON_LEFT: return
			if event.pressed: start_drag() 
			else: end_drag()
			get_viewport().set_input_as_handled()
	)
	sprite.texture = metadata.image
	logic = metadata.logic_script.new()
	logic.card_instance = self

	gamefield.event.emit("card_placement", {"card_instance": self})

func _process(_delta : float) -> void:
	if dragging:
		self.position = get_parent().get_local_mouse_position() + dragging_offset
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()

func start_drag() -> void:
	dragging = true
	dragging_offset = self.position - get_parent().get_local_mouse_position()
	print("drag")

func end_drag() -> void:
	dragging = false
	print("end drag")
